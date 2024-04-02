<#
.SYNOPSIS
This function creates a new DevSuite environment with a specified configuration.

.DESCRIPTION
The New-DevSuiteEnvironment function creates a new DevSuite environment with a specified configuration. The function uses the configuration parameters to create a JSON object, which is then sent to the DevSuite Uri via a POST web request. After initiating the creation of the environment, the function waits for up to a specified number of minutes for the environment to become available.

.PARAMETER ProjectNo
The ProjectNo parameter is a mandatory string parameter that specifies the project number.

.PARAMETER ProjectDescription
The ProjectDescription parameter is a mandatory string parameter that specifies the project description.

.PARAMETER ProjectManagement
The ProjectManagement parameter is a mandatory string parameter that specifies the project manager.

.PARAMETER CustomerNo
The CustomerNo parameter is a mandatory string parameter that specifies the customer number.

.PARAMETER CustomerName
The CustomerName parameter is a mandatory string parameter that specifies the customer name.

.PARAMETER Branch
The Branch parameter is a mandatory string parameter that specifies the branch.

.PARAMETER Department
The Department parameter is a mandatory string parameter that specifies the department.

.PARAMETER CostCenter
The CostCenter parameter is a mandatory string parameter that specifies the cost center.

.PARAMETER LeadDeveloper
The LeadDeveloper parameter is a mandatory string parameter that specifies the lead developer.

.PARAMETER ArtifactUrl
The ArtifactUrl parameter is a mandatory string parameter that specifies the artifact URL.

.PARAMETER AzureDevOps
The AzureDevOps parameter is a mandatory string parameter that specifies the Azure DevOps.

.PARAMETER KumaTarget
The KumaTarget parameter is a mandatory string parameter that specifies the Kuma target.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token for authenticating the web request.

.PARAMETER TimeoutMinutes
The TimeoutMinutes parameter is an optional integer parameter that specifies the timeout for the creation process in minutes. The default value is 45 minutes.

.EXAMPLE
New-DevSuiteEnvironment -ProjectNo "12345" -ProjectDescription "Project1" -ProjectManagement "Manager1" -CustomerNo "Cust1" -CustomerName "Customer1" -Branch "Branch1" -Department "Dept1" -CostCenter "CC1" -LeadDeveloper "Developer1" -ArtifactUrl "https://artifacturl.com" -AzureDevOps "https://azuredevops.com" -KumaTarget "Target1" -BearerToken "abc123"

This example creates a new DevSuite environment with the specified configuration, using the bearer token "abc123". The function will wait for up to 45 minutes for the environment to become available.
#>
function New-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $ProjectNo,
        [Parameter(Mandatory = $true)]
        [string] $ProjectDescription,
        [Parameter(Mandatory = $true)]
        [string] $ProjectManagement,
        [Parameter(Mandatory = $true)]
        [string] $CustomerNo,
        [Parameter(Mandatory = $true)]
        [string] $CustomerName,
        [Parameter(Mandatory = $true)]
        [string] $Branch,
        [Parameter(Mandatory = $true)]
        [string] $Department,        
        [Parameter(Mandatory = $true)]
        [string] $CostCenter,
        [Parameter(Mandatory = $true)]
        [string] $LeadDeveloper,
        [Parameter(Mandatory = $true)]
        [string] $ArtifactUrl,
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOps,
        [Parameter(Mandatory = $true)]
        [string] $KumaTarget,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 45
    )

    $jsonObject = @{
        "projectNumber"      = $ProjectNo
        "projectDescription" = $ProjectDescription
        "projectManager"     = $ProjectManagement
        "leadDeveloper"      = $LeadDeveloper
        "branch"             = $Branch
        "customerName"       = $CustomerName
        "customerNumber"     = $CustomerNo
        "department"         = $Department
        "costCenter"         = $CostCenter
        "artifactUrl"        = $ArtifactUrl
        "linkDevOps"         = $AzureDevOps
        "linkKumaTarget"     = $KumaTarget
    } | ConvertTo-Json

    $uri = Get-DevSuiteUri -Route 'vm'
    Invoke-DevSuiteWebRequest -Uri $uri -Method POST -BearerToken $BearerToken -Body $jsonObject

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {    
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)
        Write-Host "Waiting $minutes minutes: " -NoNewline
        if (Test-DevSuiteEnvironment -NameOrDescription $ProjectDescription -BearerToken $BearerToken) {            
            $devSuite = Get-DevSuiteEnvironment -NameOrDescription $ProjectDescription -BearerToken $BearerToken
            return $devSuite            
        }    
        Start-Sleep -Seconds 5
    }    
    throw "New-DevSuiteEnvironment timeout"
}
Export-ModuleMember -Function  New-DevSuiteEnvironment



