$configPath = Join-Path $PSScriptRoot "PSDevelopmentSupport.config.json"  # Initial

$envConfigPath = [System.Environment]::GetEnvironmentVariable("PSDEV_CONFIG_PATH", "User") 
if ($envConfigPath -and -not $Global:ConfigPath) {
    # If set in the environment variable and not via $Global:ConfigPath
    $Global:ConfigPath = $envConfigPath  # Set new $Global:ConfigPath
}

if (($Global:ConfigPath) -and (Test-Path $Global:ConfigPath)) {
    $configPath = $Global:ConfigPath
}
else {
    $Global:ConfigPath = $configPath 
}

$Global:Config = Get-Content $configPath | ConvertFrom-Json
$Global:DevSuiteBearerToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarDevSuiteBearerToken, "User") 
$Global:JiraApiToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarJiraApiToken, 'User')
if (-not $Global:JiraApiToken) {
    throw "User environment variable '$($Global:Config.EnvVarJiraApiToken)' not set."
}
$Global:AzureDevOpsToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarAzureDevOpsToken, 'User')
if (-not $Global:AzureDevOpsToken) {
    throw "User environment variable '$($Global:Config.AzureDevOpsToken)' not set."
}

$Global:BearerTokenApplicationPath = [System.Environment]::GetEnvironmentVariable($($Global:Config.EnvVarBearerTokenApplicationPath), 'User')
if (-not $Global:BearerTokenApplicationPath) {
    throw "User environment variable '$($Global:Config.BearerTokenApplicationPath)' not set."
}


$Global:DevSuiteEnvironments = @() 