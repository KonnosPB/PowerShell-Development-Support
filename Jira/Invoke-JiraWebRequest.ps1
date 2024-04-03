<#
.SYNOPSIS
A function that sends a web request to a specified Jira API endpoint.

.DESCRIPTION
The `Invoke-JiraWebRequest` function sends a web request to a specified Jira API endpoint using the provided parameters. The function will create an authorization header using the provided Jira API token and the global email address from the configuration. The function also supports skipping error handling.

.PARAMETER Uri
A string that specifies the URI of the Jira API endpoint.

.PARAMETER Method
A string that specifies the HTTP method to be used. It must be either "GET", "POST", or "PATCH".

.PARAMETER JiraApiToken
A string that contains the Jira API token. This token is used for authorization.

.PARAMETER Body
An optional object that contains the body of the request. If provided, the function will also include a "Content-Type" header with the value specified in the ContentType parameter.

.PARAMETER ContentType
An optional string that specifies the content type of the body. The default value is 'application/json'.

.PARAMETER SkipErrorHandling
An optional switch that indicates whether error handling should be skipped. If this parameter is set to true, the function will not throw an exception if the response status code is not in the range 200-299.

.EXAMPLE
Invoke-JiraWebRequest -Uri 'https://your-jira-instance.atlassian.net/rest/api/2/issue/ISSUE-123' -Method 'GET' -JiraApiToken 'your-api-token'

This will send a GET request to the specified URI with the provided API token.

.EXAMPLE
Invoke-JiraWebRequest -Uri 'https://your-jira-instance.atlassian.net/rest/api/2/issue/' -Method 'POST' -JiraApiToken 'your-api-token' -Body $body -ContentType 'application/json'

This will send a POST request to the specified URI with the provided API token and body content.
#>
function Invoke-JiraWebRequest {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Uri,      
        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string] $Method,      
        [Parameter(Mandatory = $true)]
        [string] $JiraApiToken,
        [Parameter(Mandatory = $false)]
        [object] $Body,
        [Parameter(Mandatory = $false)]
        [string] $ContentType = 'application/json',
        [Parameter(Mandatory = $false)]
        [switch] $SkipErrorHandling
    )
    $authorizationContent = $JiraApiToken
    $basicAuthorizationContent = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($authorizationContent )))"
    $authHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $authHeaders.Add("Authorization", $basicAuthorizationContent)

    $callingCommandFile = Split-Path $MyInvocation.PSCommandPath -Leaf | ForEach-Object { $_ -replace '\.[^.]+$', '' }

    if ($Body) {
        $authHeaders.Add("Content-Type", $ContentType)
        Write-Host "$callingCommandFile : Invoke-JiraWebRequest -Uri $Uri -Method $Method -Body $Body" -NoNewline  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders -Body $Body  
    }
    else {
        Write-Host "$callingCommandFile : Invoke-JiraWebRequest -Uri $Uri -Method $Method" -NoNewline  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders 
    }  
    
    if ($result.StatusCode -ge 200 -and $result.StatusCode -lt 300) {
        Write-Host " ✅"
        return($result);
    }
    else {
        Write-Host " ❌"
        if (!$SkipErrorHandling) {
            throw "$($result.StatusCode) $($result.StatusDescription)" 
        }
    }
}
Export-ModuleMember -Function Invoke-JiraWebRequest