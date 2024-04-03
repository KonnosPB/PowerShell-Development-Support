<#
.SYNOPSIS
This function installs a Business Central App package in a specified DevSuite and Tenant.

.DESCRIPTION
The Install-DevSuiteBCAppPackage function takes a DevSuite, Tenant, AppName, optional TestApp, Preview and TimeoutMinutes parameters. It checks for the availability of the app in the devsuite. If the app is available, it initiates the installation process and waits until the app is published or the timeout period is reached.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite in which the App package is to be installed.

.PARAMETER Tenant
This is a mandatory parameter that specifies the Tenant in which the App package is to be installed.

.PARAMETER AppName
This is a mandatory parameter that specifies the name of the App package to be installed.

.PARAMETER TestApp
This is an optional switch parameter. If specified, the function will consider the App package as a Test App.

.PARAMETER Preview
This is an optional switch parameter. If specified, the function will consider the App package as a Preview.

.PARAMETER TimeoutMinutes
This is an optional parameter that specifies the timeout period for the installation process. If not specified, the default timeout is 5 minutes.

.EXAMPLE
Install-DevSuiteBCAppPackage -DevSuite "DevSuite1" -Tenant "Tenant1" -AppName "App1" -TimeoutMinutes 10

This example installs the "App1" package in "DevSuite1" and "Tenant1" with a timeout period of 10 minutes.
#>
function Install-DevSuiteBCAppPackage {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $true)]
        [string] $AppName,
        [Parameter(Mandatory = $false)]
        [Switch] $TestApp,
        [Parameter(Mandatory = $false)]
        [Switch] $Preview,
        [Parameter(Mandatory = $false)]
        [string] $TimeoutMinutes = 5  
    )   

    $selectedApp = Get-DevSuiteAvailableBCAppPackage -DevSuite $DevSuite -AppName $AppName -TestApp:$TestApp -Preview:$Preview  
    if (-not $selectedApp) {
        throw "No available app $AppName in devsuite $DevSuite"
    }

    $versionParts = $selectedApp.appVersion.Split('.')[0..2]
    $versionFirstThree = [string]::Join('.', $versionParts)

    $obj = @{
        "AppId"             = $selectedApp.appId   # $selectedApp.uPackName                
        "AppRuntimeVersion" = $selectedApp.uPackGroup
        "AppVersion"        = $versionFirstThree  # $selectedApp.uPackVersion
        "ProcessingId"      = [guid]::NewGuid().ToString()
        "Task"              = "install"
    } 
    $objs = @()
    $objs += $obj    
    $body = ConvertTo-Json -InputObject $objs
    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/tenant/$Tenant/bcapps"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'PATCH' -Body $body
    
    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) { 
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Host "Waiting $minutes minutes: " -NoNewline   
        $publishedApps = Get-DevSuitePublishedBCAppPackages -DevSuite $DevSuite -Tenant $Tenant
        $publishedApp = $publishedApps | Where-Object ({ $_.appId -eq $selectedApp.appId })
        if ($publishedApp) {
            return $publishedApp
        }        
        Start-Sleep -Seconds 5
    }    
    return $null
}

Export-ModuleMember -Function Install-DevSuiteBCAppPackage