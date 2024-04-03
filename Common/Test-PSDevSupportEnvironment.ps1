<#
.SYNOPSIS
This function checks if the necessary environment variables and paths for DevSuite, Jira and AzureDevOps are set and exist.

.DESCRIPTION
The Test-PSDevSupportEnvironment function checks if the necessary environment variables for DevSuite, Jira and AzureDevOps are available in the system. 
If any of the required environment variables are missing, the function will throw an error. If the environment variables are set correctly, the function will print a confirmation.
The function also checks if the path to the BearerTokenApplication is available. If not, an error will be thrown.

.EXAMPLE
PS C:\> Test-PSDevSupportEnvironment

This command will run the function and check for the required environment variables and path.
If any of them are missing, an error message will be displayed. If all of them are correctly set, a confirmation message will be displayed for each.
#>
function Test-PSDevSupportEnvironment {     

    $DevSuiteBearerToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarDevSuiteBearerToken, "User") 
    if (-not $DevSuiteBearerToken) {
        Write-Error "❌ Environment variable '$($Global:Config.EnvVarDevSuiteBearerToken)' missing" 
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarDevSuiteBearerToken)' Environment variable " 
    }

    $JiraApiToken = [System.Environment]::GetEnvironmentVariable($($Global:Config.EnvVarJiraApiToken), 'Machine')
    if (-not $JiraApiToken) {
        Write-Error "❌ Environment variable '$($Global:Config.EnvVarJiraApiToken)' missing" 
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarJiraApiToken)' environment variable" 
    }

    $AzureDevOpsToken = [System.Environment]::GetEnvironmentVariable($($Global:Config.EnvVarAzureDevOpsToken), 'Machine')
    if (-not $AzureDevOpsToken) {
        Write-Error "❌ Environment variable '$($Global:Config.EnvVarAzureDevOpsToken)' missing" 
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarAzureDevOpsToken)' environment variable" 
    }  
   
    if (Test-Path $Global:Config.BearerTokenApplicationPath) {
        Write-Host "✅ '$($Global:Config.BearerTokenApplicationPath)' path exist"         
    }
    else {
        Write-Error "❌ '$($Global:Config.BearerTokenApplicationPath)' path doesn't exist"             
    } 
   
}
Export-ModuleMember -Function Test-PSDevSupportEnvironment
