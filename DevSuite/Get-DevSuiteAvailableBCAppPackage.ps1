<#
.SYNOPSIS
This function retrieves the available BC app package from the specified DevSuite.

.DESCRIPTION
The function Get-DevSuiteAvailableBCAppPackage retrieves the specified BC app package information from the provided DevSuite. 
The function filters the app packages based on the provided AppName, TestApp, and Preview switches. The function returns the app package sorted by the app version.

.PARAMETER DevSuite
This parameter specifies the name or description of the DevSuite from which the app package information is to be retrieved. 
This is a mandatory parameter.

.PARAMETER AppName
This parameter specifies the name of the app for which the package information is to be retrieved from the DevSuite. 
This is a mandatory parameter.

.PARAMETER TestApp
This switch parameter determines whether to include test apps in the retrieved app packages. 
If not specified, the function will exclude test apps from the retrieved app packages.

.PARAMETER Preview
This switch parameter determines whether to include preview apps in the retrieved app packages. 
If not specified, the function will exclude preview apps from the retrieved app packages.

.EXAMPLE
PS C:\> Get-DevSuiteAvailableBCAppPackage -DevSuite "DevSuite1" -AppName "App1"
This command retrieves the app package information for the app named "App1" from the DevSuite named "DevSuite1".

.EXAMPLE
PS C:\> Get-DevSuiteAvailableBCAppPackage -DevSuite "DevSuite1" -AppName "App1" -TestApp
This command retrieves the app package information for the app named "App1" from the DevSuite named "DevSuite1", including test apps.

.EXAMPLE
PS C:\> Get-DevSuiteAvailableBCAppPackage -DevSuite "DevSuite1" -AppName "App1" -Preview
This command retrieves the app package information for the app named "App1" from the DevSuite named "DevSuite1", including preview apps.
#>
function Get-DevSuiteAvailableBCAppPackage {
    Param (        
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $true, Position = 1)]
        [Alias("App")]
        [string] $AppName,
        [Parameter(Mandatory = $false)]
        [Switch] $TestApp,
        [Parameter(Mandatory = $false)]
        [Switch] $Preview       
    )
    BEGIN {
        Write-Debug "Getting app package info of $AppName from devsuite '$DevSuite'" 
    }

    PROCESS {   

        $appPackages = Get-DevSuiteAvailableBCAppPackages -DevSuite $DevSuite
        $selectedAppPackages = $appPackages | Where-Object { $_.name -eq $AppName } 
        if (-not $TestApp) {
            $selectedAppPackages = $selectedAppPackages  | Where-Object { $_.isTestApp -eq $false }
        }

        if (-not $Preview) {
            $selectedAppPackages = $selectedAppPackages  | Where-Object { $_.isPreview -eq $false }
        }

        $selectedApp = $selectedAppPackages | Sort-Object { [Version] ($_.appVersion -replace "-dev$") } | Select-Object -Last 1       
        Write-Output $selectedApp
    }
    END {}  
}

Export-ModuleMember -Function Get-DevSuiteAvailableBCAppPackage
New-Alias "Get-DevSuiteApp" -Value Get-DevSuiteAvailableBCAppPackage
New-Alias "Get-DevSuiteAppPackage" -Value Get-DevSuiteAvailableBCAppPackage
New-Alias "Get-DevSuitePackage" -Value Get-DevSuiteAvailableBCAppPackage
