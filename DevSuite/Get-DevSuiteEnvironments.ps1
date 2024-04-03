<#
.SYNOPSIS
This function retrieves the environments from the DevSuite.

.DESCRIPTION
The Get-DevSuiteEnvironments function makes a GET web request to the DevSuite's "vm" route. It parses the JSON response and returns it. If the web request fails or an error occurs, it returns false or an empty array respectively.

.PARAMETER
The function does not take any parameters.

.EXAMPLES
Example 1: Get-DevSuiteEnvironments
This example calls the function without any parameters. It returns a JSON object with the environments from the DevSuite.

#>
function Get-DevSuiteEnvironments {
    try {
        $uri = Get-DevSuiteUri -Route "vm" -Parameter "clearCache=false"
        $result = Invoke-DevSuiteWebRequest -Uri $uri -Method "GET" -SkipErrorHandling
        if ($result.StatusCode -ne 200) {
            return false;
        }
        $jsonDevSuite = $result.Content | ConvertFrom-Json
        return $jsonDevSuite;        
    }
    catch {
        return @()
    }
}
Export-ModuleMember -Function Get-DevSuiteEnvironments