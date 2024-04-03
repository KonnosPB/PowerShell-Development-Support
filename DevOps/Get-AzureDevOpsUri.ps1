<#
.SYNOPSIS
This function constructs and returns a Azure DevOps Uri.

.DESCRIPTION
The Get-AzureDevOpsUri function is used to construct a Azure DevOps Uri. This Uri contains the base Uri (https://dev.azure.com/) followed by the AzureDevOpsOrganisation from the global configuration, the AzureDevOpsProject and an optional Route and Parameter.

.PARAMETER AzureDevOpsProject
The name of the Azure DevOps Project. This is a mandatory parameter.

.PARAMETER Route
The route is the specific path within the Azure DevOps Project. This is a mandatory parameter.

.PARAMETER Parameter
This is an optional parameter that can be added to the Uri to specify additional query options.

.EXAMPLE
$Uri = Get-AzureDevOpsUri -AzureDevOpsProject "MyProject" -Route "Builds"

This example constructs a Uri for the "Builds" route in the "MyProject" Azure DevOps Project.

.EXAMPLE
$Uri = Get-AzureDevOpsUri -AzureDevOpsProject "MyProject" -Route "Builds" -Parameter "definitionId=1"

This example constructs a Uri for the "Builds" route in the "MyProject" Azure DevOps Project and adds the "definitionId=1" query parameter to the Uri.
#>
function Get-AzureDevOpsUri {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject,
        [Parameter(Mandatory = $true)]
        [string] $Route,        
        [Parameter(Mandatory = $false)]
        [string] $Parameter = $null        
    )
    $uri = "https://dev.azure.com/$($Global:Config.AzureDevOpsOrganisation)/$AzureDevOpsProject/"
    if ($Route) {
        $uri += $Route
    }       
    if ($Parameter) {
        $uri += "?$Parameter"
    }
    return($uri)
}
Export-ModuleMember -Function Get-AzureDevOpsUri