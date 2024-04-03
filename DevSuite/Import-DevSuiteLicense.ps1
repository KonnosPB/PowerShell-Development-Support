<#
.SYNOPSIS
This function imports a DevSuite license.

.DESCRIPTION
The Import-DevSuiteLicense function takes two mandatory parameters, DevSuite and LicensePath. The function first checks if the license file exists at the provided path. If the file does not exist, an exception is thrown. If the file exists, a bearer token is obtained and an HTTP request is sent to upload the license. If the request is successful (HTTP status code 200-299), a confirmation message is displayed and the response is returned. If the request fails (HTTP status code outside 200-299), an error message is displayed. If error handling is not skipped, an exception is thrown with the status code and description.

.PARAMETER DevSuite
The DevSuite parameter is a mandatory string that specifies the DevSuite.

.PARAMETER LicensePath
The LicensePath parameter is a mandatory string that specifies the path to the license file.

.EXAMPLE
Import-DevSuiteLicense -DevSuite "Suite1" -LicensePath "C:\Licenses\suite1.lic"

This example imports the "suite1.lic" license for the "Suite1" DevSuite. If the license file is not found at the specified path, an exception is thrown. If the file is found, it is uploaded and a confirmation message is displayed. If the upload fails, an error message is displayed and an exception is thrown (unless error handling is skipped).
#>
function Import-DevSuiteLicense {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $LicensePath
    )

    if (-not (Test-Path -Path $LicensePath)) {
        throw "'$LicensePath' not found"
    }

    $bearerToken = Get-DevSuiteBearerToken

    $authHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $authHeaders.Add("Authorization", $bearerToken)

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/uploadLicense"    
    $result = Invoke-WebRequest -Uri $uri -Method Post -InFile $LicensePath -ContentType "application/octet-stream" -Headers $authHeaders -SkipHttpErrorCheck 

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

    return $appPackages
}

Export-ModuleMember -Function Import-DevSuiteLicense