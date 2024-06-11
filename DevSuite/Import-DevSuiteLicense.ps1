<#
.SYNOPSIS
This function imports a DevSuite license.

.DESCRIPTION
The Import-DevSuiteLicense function takes two mandatory parameters, DevSuite and Path. The function first checks if the license file exists at the provided path. If the file does not exist, an exception is thrown. If the file exists, a bearer token is obtained and an HTTP request is sent to upload the license. If the request is successful (HTTP status code 200-299), a confirmation message is displayed and the response is returned. If the request fails (HTTP status code outside 200-299), an error message is displayed. If error handling is not skipped, an exception is thrown with the status code and description.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string that specifies the DevSuite.

.PARAMETER Path
The Path parameter is a mandatory string that specifies the path to the license file.

.EXAMPLE
Import-DevSuiteLicense -DevSuite "Suite1" -Path "C:\Licenses\suite1.lic"

This example imports the "suite1.lic" license for the "Suite1" DevSuite. If the license file is not found at the specified path, an exception is thrown. If the file is found, it is uploaded and a confirmation message is displayed. If the upload fails, an error message is displayed and an exception is thrown (unless error handling is skipped).
#>
function Import-DevSuiteLicense {
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias("Name", "Description", "NameOrDescription")]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    Write-Host "Importing licence '$Path' for all tenants into devsuite '$DevSuite'" -ForegroundColor Green

    if (-not (Test-Path -Path $Path)) {
        throw "'$Path' not found"
    }

    $bearerToken = Get-DevSuiteBearerToken

    $authHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $authHeaders.Add("Authorization", $bearerToken)
    #$authHeaders.Add("Connection", 'keep-alive')

    $devSuiteObj = Get-DevSuiteEnvironment -DevSuite $DevSuite
    $devSuiteName = $devSuiteObj.name
    $route = "vm/$devSuiteName/uploadLicense"    
    $uri = Get-DevSuiteUri -Route $route
    $script:result = Invoke-WebRequest -Uri $uri -Method Post -InFile $Path -ContentType "application/octet-stream" -Headers $authHeaders -SkipHttpErrorCheck

    if ($script:result.StatusCode -ge 200 -and $script:result.StatusCode -lt 300) {       
        return($script:result);
    }
    else {        
        if (!$SkipErrorHandling) {
            $errorMessage = "$($script:result.StatusCode) $($script:result.StatusDescription)" 
            throw $errorMessage
        }
    }

    return $appPackages
}

Export-ModuleMember -Function Import-DevSuiteLicense