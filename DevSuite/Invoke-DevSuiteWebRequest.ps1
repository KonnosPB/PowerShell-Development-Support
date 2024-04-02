<#
.SYNOPSIS
This function makes a web request to a specified URI using the specified method and authentication headers.

.DESCRIPTION
The Invoke-DevSuiteWebRequest function makes a web request to a specified URI using the specified HTTP method (GET, POST, or PATCH) and authentication headers. If a body is supplied, the function includes it in the request and sets the Content-Type header to 'application/json'. The function writes the status of the request to the host and returns the response if the status code is between 200 and 300. If the status code is outside this range and the SkipErrorHandling switch is not included, the function throws an exception.

.PARAMETER Uri
The Uri parameter is a mandatory string parameter that specifies the URI to which the web request is made.

.PARAMETER Method
The Method parameter is a mandatory string parameter that specifies the HTTP method used for the web request. It must be one of the following values: GET, POST, PATCH.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token used in the Authorization header of the web request.

.PARAMETER Body
The Body parameter is an optional object parameter that specifies the body of the web request. If supplied, the function includes the body in the request and sets the Content-Type header to 'application/json'.

.PARAMETER ContentType
The ContentType parameter is an optional string parameter that specifies the value of the Content-Type header in the web request. The default value is 'application/json'.

.PARAMETER SkipErrorHandling
The SkipErrorHandling parameter is an optional switch parameter that, when included, prevents the function from throwing an exception when the status code of the response is outside the range 200-300.

.EXAMPLE
Invoke-DevSuiteWebRequest -Uri "https://api.example.com" -Method "GET" -BearerToken "abc123"

This example makes a GET request to "https://api.example.com" using the bearer token "abc123".
#>
function Invoke-DevSuiteWebRequest {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $Uri,      
        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string] $Method,      
        [Parameter(Mandatory = $true)]
        [string] $BearerToken,
        [Parameter(Mandatory = $false)]
        [object] $Body,
        [Parameter(Mandatory = $false)]
        [string] $ContentType = 'application/json',
        [Parameter(Mandatory = $false)]
        [switch] $SkipErrorHandling        
    )

    $authHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $authHeaders.Add("Authorization", $BearerToken)

    $callingCommandFile = Split-Path $MyInvocation.PSCommandPath -Leaf | ForEach-Object { $_ -replace '\.[^.]+$', '' }

    if ($Body) {
        $authHeaders.Add("Content-Type", $ContentType)
        Write-Host "$callingCommandFile : Invoke-DevSuiteWebRequest -Uri $Uri -Method $Method -Body $Body" -NoNewline  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders -Body $Body  
    }
    else {
        Write-Host "$callingCommandFile : Invoke-DevSuiteWebRequest -Uri $Uri -Method $Method" -NoNewline  
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
Export-ModuleMember -Function Invoke-DevSuiteWebRequest