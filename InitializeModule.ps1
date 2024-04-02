$Global:Config = Get-Content "PSDevelopmentSupport.config.json" | ConvertFrom-Json
$Global:DevSuiteBearerToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarDevSuiteBearerToken, "User") 
$Global:JiraApiToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarJiraApiToken, 'User')
if (-not $Global:JiraApiToken){
    throw "User environment variable '$($Global:Config.EnvVarJiraApiToken)' not set."
}
$Global:AzureDevOpsToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarAzureDevOpsToken, 'User')
if (-not $Global:AzureDevOpsToken){
    throw "User environment variable '$($Global:Config.EnvVarJiraApiToken)' not set."
}
$Global:DevSuiteEnvironments = @() 