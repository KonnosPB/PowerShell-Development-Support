$modulePath = Join-Path $PSScriptRoot "..\PSDevelopmentSupport.psd1"
Test-ModuleManifest -Path $modulePath
Remove-Module $modulePath  -Force -ErrorAction SilentlyContinue
Import-Module $modulePath -Force -DisableNameChecking -ErrorAction SilentlyContinue

$modulePath = Join-Path $PSScriptRoot "..\PSDevelopmentSupport.psm1"
Invoke-ScriptAnalyzer -Path $modulePath
Remove-Module $modulePath -Force -ErrorAction SilentlyContinue
Import-Module $modulePath -Force -DisableNameChecking -ErrorAction SilentlyContinue

Get-PSSession | Remove-PSSession

if (-not (Test-Path -Path $Global:Config.BearerTokenApplicationPath)){
    throw "Environment variable '$($Global:Config.BearerTokenApplicationPath)' which contains the path to the bearer token helper application not set"
}
if (-not (Test-DevSuiteBearerToken -BearerToken $Global:DevSuiteBearerToken)){
    Update-DevSuiteBearerToken -BearerTokenApplication $Global:Config.BearerTokenApplicationPath
}