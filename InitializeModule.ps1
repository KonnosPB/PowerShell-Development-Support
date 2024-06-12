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


#region Helper Functions
function ReplaceCDN {
    Param(
        [string] $sourceUrl,
        [switch] $useBlobUrl
    )

    $bcCDNs = @(
        @{ "oldCDN" = "bcartifacts.azureedge.net";         "newCDN" = "bcartifacts-exdbf9fwegejdqak.b02.azurefd.net";         "blobUrl" = "bcartifacts.blob.core.windows.net" },
        @{ "oldCDN" = "bcinsider.azureedge.net";           "newCDN" = "bcinsider-fvh2ekdjecfjd6gk.b02.azurefd.net";           "blobUrl" = "bcinsider.blob.core.windows.net" },
        @{ "oldCDN" = "bcpublicpreview.azureedge.net";     "newCDN" = "bcpublicpreview-f2ajahg0e2cudpgh.b02.azurefd.net";     "blobUrl" = "bcpublicpreview.blob.core.windows.net" },
        @{ "oldCDN" = "businesscentralapps.azureedge.net"; "newCDN" = "businesscentralapps-hkdrdkaeangzfydv.b02.azurefd.net"; "blobUrl" = "businesscentralapps.blob.core.windows.net" },
        @{ "oldCDN" = "bcprivate.azureedge.net";           "newCDN" = "bcprivate-fmdwbsb3ekbkc0bt.b02.azurefd.net";           "blobUrl" = "bcprivate.blob.core.windows.net" }
    )

    foreach($cdn in $bcCDNs) {
        $found = $false
        $cdn.blobUrl, $cdn.newCDN, $cdn.oldCDN | ForEach-Object {
            if ($sourceUrl.ToLowerInvariant().StartsWith("https://$_/")) {
                $sourceUrl = "https://$(if($useBlobUrl){$cdn.blobUrl}else{$cdn.newCDN})/$($sourceUrl.Substring($_.Length+9))"
                $found = $true
            }
            if ($sourceUrl -eq $_) {
                $sourceUrl = "$(if($useBlobUrl){$cdn.blobUrl}else{$cdn.newCDN})"
                $found = $true
            }
        }
        if ($found) {
            break
        }
    }
    $sourceUrl
}
#endregion