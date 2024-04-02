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
    
    if (-not $Global:Config.JiraEMailAddress) {
        Write-Error "❌ Environment variable '$($Global:Config.JiraEMailAddress)' missing" 
    }
    else {
        Write-Host "✅ '$($Global:Config.JiraEMailAddress)' environment variable" 
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
