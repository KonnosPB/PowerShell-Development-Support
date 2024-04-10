<#
.SYNOPSIS
This function is used to send a web request to Azure DevOps.

.DESCRIPTION
The function "Invoke-AzureDevOpsWebRequest" sends a GET, POST, or PATCH request to a specified URI with the provided Azure DevOps token. The request can optionally include a body and a content type. If the request results in an HTTP status code outside of the 200-299 range, an exception will be thrown unless error handling is explicitly skipped.

.PARAMETER Uri
This parameter specifies the URI to which the web request will be sent. This parameter is mandatory.

.PARAMETER Method
This parameter specifies the HTTP method of the web request. The method must be either "GET", "POST", or "PATCH". This parameter is mandatory.

.PARAMETER AzureDevOpsToken
This parameter is the Azure DevOps token used for authorization. This parameter is mandatory.

.PARAMETER Body
This parameter is the body of the web request. It is not mandatory.

.PARAMETER ContentType
This parameter specifies the content type of the web request body. Its default value is 'application/json'. It is not mandatory.

.PARAMETER SkipErrorHandling
This is a switch parameter. If set, error handling will be skipped, meaning that HTTP status codes outside of the 200-299 range will not result in an exception being thrown. It is not mandatory.

.EXAMPLE
Invoke-AzureDevOpsWebRequest -Uri 'https://dev.azure.com/organization/_apis/projects?api-version=5.1' -Method 'GET' -AzureDevOpsToken 'mypat' -Body $body -ContentType 'application/json' -SkipErrorHandling

This example sends a 'GET' request to the specified URI with the provided Azure DevOps token and body. The content type of the body is set to 'application/json'. Error handling is skipped.
#>
function Invoke-AzureDevOpsWebRequest {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Uri,      
        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string] $Method,      
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOpsToken,
        [Parameter(Mandatory = $false)]
        [object] $Body,
        [Parameter(Mandatory = $false)]
        [string] $ContentType = 'application/json',
        [Parameter(Mandatory = $false)]
        [switch] $SkipErrorHandling
    )

    $authHeaders = @{ Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$AzureDevOpsToken")))" }

    $callingCommandFile = Split-Path $MyInvocation.PSCommandPath -Leaf | ForEach-Object { $_ -replace '\.[^.]+$', '' }

    if ($Body) {
        $authHeaders.Add("Content-Type", $ContentType)
        Write-Host "$callingCommandFile : Invoke-DevSuiteWebRequest -Uri $Uri -Method $Method -Body $Body"  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders -Body $Body -SkipHttpErrorCheck 
    }
    else {
        Write-Host "$callingCommandFile : Invoke-DevSuiteWebRequest -Uri $Uri -Method $Method"  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders -SkipHttpErrorCheck 
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
Export-ModuleMember -Function Invoke-AzureDevOpsWebRequest