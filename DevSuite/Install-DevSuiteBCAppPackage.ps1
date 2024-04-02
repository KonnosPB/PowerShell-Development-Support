<#
.SYNOPSIS
This function installs the app packages for a specified DevSuite and Tenant.

.DESCRIPTION
The Install-DevSuiteBCAppPackage function installs app packages for a specified DevSuite and Tenant. The function retrieves the available app package for the given DevSuite and AppName, and throws an error if no such app is available. If the app is available, the function requests an installation of the app to the specified Tenant in the DevSuite.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the name of the DevSuite.

.PARAMETER Tenant
The Tenant parameter is a mandatory string parameter that specifies the name of the Tenant.

.PARAMETER AppName
The AppName parameter is a mandatory string parameter that specifies the name of the app to be installed.

.PARAMETER TestApp
The TestApp parameter is an optional switch parameter that specifies whether the app is a test app.

.PARAMETER Preview
The Preview parameter is an optional switch parameter that specifies whether the app is a preview app.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.PARAMETER TimeoutMinutes
The TimeoutMinutes parameter is an optional string parameter that specifies the timeout for the installation process in minutes. The default value is 5 minutes.

.EXAMPLE
Install-DevSuiteBCAppPackage -DevSuite "DevSuite1" -Tenant "Tenant1" -AppName "App1" -BearerToken "abc123"

This example installs the app named "App1" for the DevSuite named "DevSuite1" and the Tenant named "Tenant1", using the bearer token "abc123". The function will wait for up to 5 minutes for the installation to complete.
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
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,
        [Parameter(Mandatory = $false)]
        [string] $TimeoutMinutes = 5  
    )   

    $selectedApp = Get-DevSuiteAvailableBCAppPackage -DevSuite $DevSuite -AppName $AppName -TestApp:$TestApp -Preview:$Preview -BearerToken $BearerToken  
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
    Invoke-DevSuiteWebRequest -Uri $uri -Method 'PATCH' -BearerToken $BearerToken -Body $body
    
    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) { 
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Host "Waiting $minutes minutes: " -NoNewline   
        $publishedApps = Get-DevSuitePublishedBCAppPackages -DevSuite $DevSuite -Tenant $Tenant -BearerToken $BearerToken
        $publishedApp = $publishedApps | Where-Object ({ $_.appId -eq $selectedApp.appId })
        if ($publishedApp) {
            return $publishedApp
        }        
        Start-Sleep -Seconds 5
    }    
    return $null
}

Export-ModuleMember -Function Install-DevSuiteBCAppPackage