<#
.SYNOPSIS
A function to generate Jira API URIs.

.DESCRIPTION
The Get-JiraUri function builds and returns a Jira API URI. It takes in two parameters, the Route and the Parameter.
The Route parameter refers to the path of the API, while the Parameter refers to any additional parameters that are to be added to the URI. If the Parameter is not provided, the function will return a URI without any additional parameters.

.PARAMETER Route
This is a mandatory parameter. It should be a string representing the path of the Jira API you wish to access.

.PARAMETER Parameter
This is an optional parameter. If provided, it should be a string representing any additional parameters you wish to add to the URI. If it is not provided, the function will return a URI without any additional parameters.

.EXAMPLES
Example 1:
PS> Get-JiraUri -Route "issue/ISSUE-1234" -Parameter "fields=summary,status"
This example returns the URI for the Jira API to get the summary and status fields for the issue with key ISSUE-1234.

Example 2:
PS> Get-JiraUri -Route "issue/ISSUE-1234"
This example returns the URI for the Jira API to get all fields for the issue with key ISSUE-1234. No additional parameters are added to the URI.
#>
function Get-JiraUri{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Route,
        [Parameter(Mandatory=$false)]
        [string] $Parameter = $null        
    )
    $uri = $Global:Config.JiraBaseUrl     
    if ($Route){
        $uri += $Route
    }       
    if ($Parameter){
        $uri += "?$Parameter"
    }
    return($uri)
}
Export-ModuleMember -Function Get-JiraUri