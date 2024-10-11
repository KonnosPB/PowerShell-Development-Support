function Get-PSDevelopmentConfig {    
    if (-not $Global:Config){
        $Global:Config = Get-Content $configPath | ConvertFrom-Json
    }
    return $Global:Config
}   

Export-ModuleMember -Function Get-PSDevelopmentConfig
    