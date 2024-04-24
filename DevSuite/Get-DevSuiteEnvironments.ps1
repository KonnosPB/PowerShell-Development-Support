<#
.SYNOPSIS
This function retrieves all devsuite environments.

.DESCRIPTION
The Get-DevSuiteEnvironments function makes a GET request to the specified DevSuite URI and retrieves all the environments. The function uses the Get-DevSuiteUri function to construct the URI and the Invoke-DevSuiteWebRequest function to make the request.

.PARAMETER
No parameter is needed for this function.

.EXAMPLE
Get-DevSuiteEnvironments

This example demonstrates how to call the function to get all devsuite environments.
#>
function Get-DevSuiteEnvironments {   
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateSet("Healthcare", "Medtec")]        
        [string] $Solution
    ) 
    BEGIN {
        Write-Debug "Getting all devsuite environments" 
    }

    PROCESS {              
        $script:Regex = ".*"
        if ($Solution -eq "Medtec") {
            $script:Regex = "(MEDTEC|MTC).*Produkt.*"            
        }elseif($Solution -eq "Healthcare")  {
            $script:Regex = "(HC|Healthcare).*Produkt.*"            
        }

        $uri = Get-DevSuiteUri -Route "vm" -Parameter "clearCache=false"
        $result = Invoke-DevSuiteWebRequest -Uri $uri -Method "GET"
        if ($result.StatusCode -ne 200) {
            Write-Output $null
            return
        }
        $jsonDevSuites = $result.Content | ConvertFrom-Json 
        $jsonDevSuites = $jsonDevSuites | Where-Object {$_.projectDescription -match $script:Regex}
        foreach ($jsonDevSuite in $jsonDevSuites) {                
            Write-Output $jsonDevSuite
        }                       
    }
    END {}  
}
Export-ModuleMember -Function Get-DevSuiteEnvironments
New-Alias "Get-DevSuites" -Value Get-DevSuiteEnvironment