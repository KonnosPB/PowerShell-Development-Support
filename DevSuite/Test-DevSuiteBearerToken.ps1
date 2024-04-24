<#
.SYNOPSIS
This function verifies whether a provided BearerToken is valid for accessing DevSuite.

.DESCRIPTION
The Test-DevSuiteBearerToken function validates the provided BearerToken by making a GET request to the DevSuite Uri. It returns false if the status code of the response is not 200 or if the response content is not valid JSON. If the request is successful and the response content is valid JSON, the function returns true.

.PARAMETER BearerToken
The BearerToken parameter is a mandatory string parameter that specifies the bearer token to be validated. This parameter allows an empty string.

.EXAMPLE
Test-DevSuiteBearerToken -BearerToken "abc123"

This example verifies whether the bearer token "abc123" is valid for accessing DevSuite. The function returns true if the token is valid, and false otherwise.
#>
function Test-DevSuiteBearerToken {
    Param (       
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()] 
        [string] $BearerToken
    )   
    try {
        $uri = Get-DevSuiteUri -Route "vm" -Parameter "clearCache=false"        
        $authHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $authHeaders.Add("Authorization", $bearerToken)    
        $authHeaders.Add("Connection", 'keep-alive')       
        $result = Invoke-WebRequest -Uri $uri -Method GET -Headers $authHeaders  
    
        if ($result.StatusCode -ge 200 -and $result.StatusCode -lt 300) {            
            return($true)
        }
        else {
            return $false
        }        
    }
    catch {
        Write-Debug $_
        return $false
    }    
}
Export-ModuleMember -Function Test-DevSuiteBearerToken