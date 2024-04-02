<#
.SYNOPSIS
This function fetches all repositories from a given Azure DevOps Project.

.DESCRIPTION
The Get-AzureDevOpsRepositories function utilizes the Azure DevOps REST API to retrieve all repositories from a specified Azure DevOps Project. The function requires two parameters: the project name and a valid access token. 

.PARAMETER AzureDevOpsProject
This parameter accepts a string value that represents the name of the Azure DevOps Project from which the repositories will be fetched.

.PARAMETER AzureDevOpsToken
This parameter accepts a string value that represents the access token for authenticating requests to the Azure DevOps REST API.

.EXAMPLE
Get-AzureDevOpsRepositories -AzureDevOpsProject "MyProject" -AzureDevOpsToken "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx"

This example fetches all repositories from the Azure DevOps Project named "MyProject" using the provided access token.
#>

function Get-AzureDevOpsRepositories {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsProject, 
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsToken
    )
    $uri = Get-AzureDevOpsUri -AzureDevOpsProject $AzureDevOpsProject -Route "_apis/git/repositories"
    $response = Invoke-AzureDevOpsWebRequest -Uri $uri -Method "Get" -AzureDevOpsToken $AzureDevOpsToken
    $rawResult = $response.Content | ConvertFrom-Json
    $result = @()
    foreach ($value in $rawResult.value) {
        $result += $value.Name        
    }
    return $result
}

Export-ModuleMember -Function Get-AzureDevOpsRepositories