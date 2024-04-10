<#
.SYNOPSIS
This function installs a Business Central App package in a specified DevSuite and Tenant.

.DESCRIPTION
The Install-DevSuiteBCAppPackages function takes a DevSuite, Tenant, AppName, optional TestApp, Preview and TimeoutMinutes parameters. It checks for the availability of the app in the devsuite. If the app is available, it initiates the installation process and waits until the app is published or the timeout period is reached.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite in which the App package is to be installed.

.PARAMETER Tenant
This is a mandatory parameter that specifies the Tenant in which the App package is to be installed.

.PARAMETER AppNames
This is a mandatory parameter that specifies the names of the Apps to be installed.

.PARAMETER PreviewAppNames
This is an optional switch parameter. If specified, the function will consider the App package as a Preview.

.PARAMETER TimeoutMinutes
This is an optional parameter that specifies the timeout period for the installation process. If not specified, the default timeout is 5 minutes.

.EXAMPLE
Install-DevSuiteBCAppPackages -DevSuite "DevSuite1" -Tenant "Tenant1" -AppName "App1" -TimeoutMinutes 10

This example installs the "App1" package in "DevSuite1" and "Tenant1" with a timeout period of 10 minutes.
#>
function Install-DevSuiteBCAppPackages {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Tenant,
        [Parameter(Mandatory = $false)]
        [string[]] $AppNames = @(),
        [Parameter(Mandatory = $false)]
        [string[]] $PreviewAppNames = @(),
        [Parameter(Mandatory = $false)]
        [string] $TimeoutMinutes = 5  
    )   
    
    Write-Host "Installing app packages ($([string]::Join(', ' ,$AppNames))) and preview apps ($([string]::Join(', ', $PreviewAppNames))) into devsuite '$DevSuite' tenant '$Tenant'" -ForegroundColor Green

    $objs = @()

    $selectedAppPackages = Get-DevSuiteAvailableBCAppPackages -DevSuite $DevSuite
    if ( $AppNames) {
        foreach ($AppName in $AppNames) {
            $selectedNormalAppPackages = $selectedAppPackages | Where-Object { $_.name -eq $AppName -and $_.isPreview -eq $false }       
            $selectedApp = $selectedNormalAppPackages | Sort-Object { [Version] ($_.appVersion -replace "-dev$") } | Select-Object -Last 1  
            $versionParts = $selectedApp.appVersion.Split('.')[0..2]
            $versionFirstThree = [string]::Join('.', $versionParts)
            $obj = @{
                "AppId"             = $selectedApp.appId   # $selectedApp.uPackName                
                "AppRuntimeVersion" = $selectedApp.uPackGroup
                "AppVersion"        = $versionFirstThree  # $selectedApp.uPackVersion
                "ProcessingId"      = [guid]::NewGuid().ToString()
                "Task"              = "install"
            }         
            $objs += $obj    
        }    
    }
    if ( $PreviewAppNames) {
        foreach ($AppName in $PreviewAppNames) {
            $selectedAllAppPackages = $selectedAppPackages | Where-Object { $_.name -eq $AppName }  # Inclusive isPreview
            #$selectedApp = $selectedAllAppPackages | Sort-Object { [Version] ($_.appVersion -replace "-dev$") } | Select-Object -Last 1   
            $selectedApp = $selectedAllAppPackages | Sort-Object { [Version] } | Select-Object -Last 1          
            $versionParts = $selectedApp.appVersion.Split('.')[0..2]
            $versionFirstThree = [string]::Join('.', $versionParts)
            if ($selectedApp.isPreview){
                $versionFirstThree += '-dev'
            }
            $obj = @{
                "AppId"             = $selectedApp.appId   # $selectedApp.uPackName                
                "AppRuntimeVersion" = $selectedApp.uPackGroup
                "AppVersion"        = $versionFirstThree  # $selectedApp.uPackVersion
                "ProcessingId"      = [guid]::NewGuid().ToString()
                "Task"              = "install"
            }         
            $objs += $obj    
        }    
    }
    
    $body = ConvertTo-Json -InputObject $objs
    $devSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $DevSuite
    $uri = Get-DevSuiteUri -Route "vm/$($devSuiteObj.name)/tenant/$Tenant/bcapps"
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'PATCH' -Body $body -$SkipErrorHandling
    
    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) { 
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Progress -Activity "Waiting for $minutes minutes" -Status "Running" -PercentComplete ($minutes / $TimeoutMinutes * 100)
        $publishedApps = Get-DevSuitePublishedBCAppPackages -DevSuite $DevSuite -Tenant $Tenant
        $publishedApp = $publishedApps | Where-Object ({ $_.appId -eq $selectedApp.appId })
        if ($publishedApp) {
            Write-Host "App $publishedApp successfully published" -ForegroundColor Green
            return $publishedApp
        }        
        Start-Sleep -Seconds 5
    }    
    return $null
}

Export-ModuleMember -Function Install-DevSuiteBCAppPackages