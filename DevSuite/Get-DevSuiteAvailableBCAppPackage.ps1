<#
.SYNOPSIS
This function fetches available Business Central App packages from a specified DevSuite.

.DESCRIPTION
The function Get-DevSuiteAvailableBCAppPackage uses the DevSuite and BearerToken parameters to retrieve a list of available Business Central App packages. It allows filtering by AppName, and optionally by whether the app is a Test App or a Preview. The function returns the last app in the sorted list.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite from which the available Business Central App packages will be fetched.

.PARAMETER AppName
This is a mandatory parameter that specifies the name of the app to filter from the list of available Business Central App packages.

.PARAMETER TestApp
This is an optional switch parameter. If used, the function will include Test Apps in its return. If not used, Test Apps will be excluded.

.PARAMETER Preview
This is an optional switch parameter. If used, the function will include Preview Apps in its return. If not used, Preview Apps will be excluded.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Get-DevSuiteAvailableBCAppPackage -DevSuite "DevSuite1" -AppName "AppName1" -BearerToken "1234567890"

This example fetches available Business Central App packages from DevSuite1, filters by AppName1, excludes Test Apps and Preview Apps, and uses the BearerToken 1234567890 for authentication.

.EXAMPLE
Get-DevSuiteAvailableBCAppPackage -DevSuite "DevSuite1" -AppName "AppName1" -TestApp -Preview -BearerToken "1234567890"

This example fetches available Business Central App packages from DevSuite1, filters by AppName1, includes Test Apps and Preview Apps, and uses the BearerToken 1234567890 for authentication.
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
        [Switch] $Preview,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )

    $appPackages = Get-DevSuiteAvailableBCAppPackages -DevSuite $DevSuite -BearerToken $BearerToken   
    $selectedAppPackages = $appPackages | Where-Object { $_.name -eq $AppName } 
    if (-not $TestApp) {
        $selectedAppPackages = $selectedAppPackages  | Where-Object { $_.isTestApp -eq $false }
    }

    if (-not $Preview) {
        $selectedAppPackages = $selectedAppPackages  | Where-Object { $_.isPreview -eq $false }
    }

    $selectedApp = $selectedAppPackages | Sort-Object { [Version] ($_.appVersion -replace "-dev$") } | Select-Object -Last 1   
    return  $selectedApp
}

Export-ModuleMember -Function Get-DevSuiteAvailableBCAppPackage