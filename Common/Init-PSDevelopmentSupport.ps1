<#
function Init-PSDevelopmentSupport {  
    Param (        
        [Parameter(Mandatory = $true)]
        [ValidateSet("Healthcare", "Medtec")]
        [string] $Project,       
        [Parameter(Mandatory = $true)]        
        [string] $JiraSolutionVersion,       
        [Parameter(Mandatory = $false)]
        [string] $JiraApiToken = $null,
        [Parameter(Mandatory = $false)]
        [string] $AzureDevOpsToken = $null,
        [Parameter(Mandatory = $false)]
        [string] $Output = $null
    )
    
    $configPath = Read-Host "Please enter the file off a valed PSDevelopSupport config json file"
    if ($configPath -and Test-Path($configPath)){
        $configPath = [System.Environment]::GetEnvironmentVariable("PSDEV_CONFIG_PATH", "User")
        [System.Environment]::SetEnvironmentVariable("PSDEV_CONFIG_PATH", "User")
    }else{
        Write-Warning "Skipping set environment PSDEV_CONFIG_PATH, because the path '$configPath' doesn`t exist"
    }
    
   
   PSDEV_AZURE_DEVOPS_TOKEN
   PSDEV_BEARER_TOKEN_APPLICATION
   PSDEV_JIRA_API_TOKEN
   
   PSDEV_CONFIG_PATH
[System.Environment]::SetEnvironmentVariable("PSDEV_CONFIG_PATH", "User")
   

}
Export-ModuleMember -Function Init-PSDevelopmentSupport
#>