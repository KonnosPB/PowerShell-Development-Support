<#
.SYNOPSIS
This function imports a license file into a specified DevSuite.

.DESCRIPTION
The Import-DevSuiteLicense function uses the DevSuite, LicensePath, and BearerToken parameters to import a license file into a specified DevSuite. The function will throw an error if the license file path is not found, or if the request to upload the license file returns a status code outside of the 200-299 range.

.PARAMETER DevSuite
This is a mandatory parameter that specifies the DevSuite into which the license file will be imported.

.PARAMETER LicensePath
This is a mandatory parameter that specifies the path to the license file to be imported.

.PARAMETER BearerToken
This is a mandatory parameter that specifies the Bearer Token to be used for authentication.

.EXAMPLE
Import-DevSuiteLicense -DevSuite "DevSuite1" -LicensePath "C:\path\to\license.flf" -BearerToken "1234567890"

This example imports the license file located at "C:\path\to\license.flf" into the DevSuite "DevSuite1" using the BearerToken "1234567890" for authentication.
#>
function Import-DevSuiteLicense {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $DevSuite,
        [Parameter(Mandatory = $true)]
        [string] $LicensePath,
        [Parameter(Mandatory = $true)]
        [string] $BearerToken
    )

    if (-not (Test-Path -Path $LicensePath)) {
        throw "'$LicensePath' not found"
    }

    $uri = Get-DevSuiteUri -Route "vm/$DevSuite/uploadLicense"    
    $result = Invoke-WebRequest -Uri $uri -Method Post -InFile $LicensePath -ContentType "application/octet-stream"

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