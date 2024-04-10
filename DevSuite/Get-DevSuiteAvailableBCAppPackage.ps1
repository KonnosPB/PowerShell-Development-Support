<#
.SYNOPSIS
This function retrieves the latest version of a specified application from a given DevSuite.

.DESCRIPTION
The Get-DevSuiteAvailableBCAppPackage function is used to get the latest version of a specified application package from a given DevSuite. The application package is identified by the $AppName parameter. By default, the function only returns non-test and non-preview versions of the application package, but this can be modified by using the $TestApp and $Preview switch parameters.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string parameter that specifies the DevSuite from which the application package is to be retrieved.

.PARAMETER AppName
The AppName parameter is a mandatory string parameter that specifies the name of the application package to be retrieved.

.PARAMETER TestApp
The TestApp parameter is an optional switch parameter. When this switch is used, the function will return test versions of the application package in addition to the non-test versions.

.PARAMETER Preview
The Preview parameter is an optional switch parameter. When this switch is used, the function will return preview versions of the application package in addition to the non-preview versions.

.EXAMPLE
PS C:\> Get-DevSuiteAvailableBCAppPackage -DevSuite "Suite1" -AppName "App1"
This command retrieves the latest version of the "App1" application package from the "Suite1" DevSuite.

.EXAMPLE
PS C:\> Get-DevSuiteAvailableBCAppPackage -DevSuite "Suite1" -AppName "App1" -TestApp
This command retrieves the latest version of the "App1" application package, including test versions, from the "Suite1" DevSuite.

.EXAMPLE
PS C:\> Get-DevSuiteAvailableBCAppPackage -DevSuite "Suite1" -AppName "App1" -Preview
This command retrieves the latest version of the "App1" application package, including preview versions, from the "Suite1" DevSuite.
#>
function Get-DevSuiteAvailableBCAppPackage {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $AppName,
        [Parameter(Mandatory = $false)]
        [Switch] $TestApp,
        [Parameter(Mandatory = $false)]
        [Switch] $Preview       
    )
    Write-Debug "Getting app package info of $AppName from devsuite '$DevSuite'" 

    $appPackages = Get-DevSuiteAvailableBCAppPackages -DevSuite $DevSuite
    $selectedAppPackages = $appPackages | Where-Object { $_.name -eq $AppName } 
    if (-not $TestApp) {
        $selectedAppPackages = $selectedAppPackages  | Where-Object { $_.isTestApp -eq $false }
    }

    if (-not $Preview) {
        $selectedAppPackages = $selectedAppPackages  | Where-Object { $_.isPreview -eq $false }
    }

    $selectedApp = $selectedAppPackages | Sort-Object { [Version] ($_.appVersion -replace "-dev$") } | Select-Object -Last 1   
    Write-Debug " ✅"
    return  $selectedApp
}

Export-ModuleMember -Function Get-DevSuiteAvailableBCAppPackage