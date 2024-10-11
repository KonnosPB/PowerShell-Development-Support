<#
.SYNOPSIS
This function checks if the necessary environment variables and paths for DevSuite, Jira and AzureDevOps are set and exist.

.DESCRIPTION
The Test-PSDevSupportEnvironment function checks if the necessary environment variables for DevSuite, Jira and AzureDevOps are available in the system. 
If any of the required environment variables are missing, the function will throw an error. If the environment variables are set correctly, the function will print a confirmation.
The function also checks if the path to the BearerTokenApplication is available. If not, an error will be thrown.

.EXAMPLE
PS C:\> Test-PSDevSupportEnvironment
oia
This command will run the function and check for the required environment variables and path.
If any of them are missing, an error message will be displayed. If all of them are correctly set, a confirmation message will be displayed for each.
#>
function Test-PSDevSupportEnvironment {     
    $success = $true
    $DevSuiteBearerToken = [System.Environment]::GetEnvironmentVariable($Global:Config.EnvVarDevSuiteBearerToken, "User") 
    if ([string]::IsNullOrEmpty($DevSuiteBearerToken)) {
        Write-Host"❌ Environment variable '$($Global:Config.EnvVarDevSuiteBearerToken)' missing" 
        $success = $false
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarDevSuiteBearerToken)' environment variable exist" 
    }

    $JiraApiToken = [System.Environment]::GetEnvironmentVariable($($Global:Config.EnvVarJiraApiToken), 'User')
    if ([string]::IsNullOrEmpty($JiraApiToken)) {        
        Write-Host"❌ Environment variable '$($Global:Config.EnvVarJiraApiToken)' missing" 
        $success = $false
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarJiraApiToken)' environment variable exist" 
    }

    $AzureDevOpsToken = [System.Environment]::GetEnvironmentVariable($($Global:Config.EnvVarAzureDevOpsToken), 'User')
    if ([string]::IsNullOrEmpty($AzureDevOpsToken)) {
        Write-Host"❌ Environment variable '$($Global:Config.EnvVarAzureDevOpsToken)' missing" 
        $success = $false
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarAzureDevOpsToken)' environment variable exist" 
    }  
    
    $BearerTokenApplicationPath = [System.Environment]::GetEnvironmentVariable($($Global:Config.EnvVarBearerTokenApplicationPath), 'User')
    if ([string]::IsNullOrEmpty($BearerTokenApplicationPath)) {
        Write-Host"❌ Environment variable '$($Global:Config.EnvVarBearerTokenApplicationPath)' missing" 
        $success = $false
    }
    else {
        Write-Host "✅ '$($Global:Config.EnvVarBearerTokenApplicationPath)' environment variable exist" 
    }  
   
    if (Test-Path $Global:BearerTokenApplicationPath) {
        Write-Host "✅ '$($Global:BearerTokenApplicationPath)' path exist"         
    }
    else {
        Write-Host"❌ '$($Global:BearerTokenApplicationPath)' path doesn't exist"             
        $success = $false
    } 

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteUrl)) {
        Write-Host "❌ 'DevSuiteUrl' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteUrl' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteHost)) {
        Write-Host "❌ 'DevSuiteHost' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteHost' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.JiraBaseUrl)) {
        Write-Host "❌ 'JiraBaseUrl' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'JiraBaseUrl' config exist"   
    }
    if ([string]::IsNullOrEmpty($Global:Config.DevOpsUrl)) {
        Write-Host "❌ 'DevOpsUrl' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevOpsUrl' config exist"   
    }
    if ([string]::IsNullOrEmpty($Global:Config.AzureDevOpsMedtecProject)) {
        Write-Host "❌ 'AzureDevOpsMedtecProject' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'AzureDevOpsMedtecProject' config exist"   
    }
    if ([string]::IsNullOrEmpty($Global:Config.AzureDevOpsHealthcareProject)) {
        Write-Host "❌ 'AzureDevOpsHealthcareProject' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'AzureDevOpsHealthcareProject' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.AzureDevOpsOrganisation)) {
        Write-Host "❌ 'AzureDevOpsOrganisation' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'AzureDevOpsOrganisation' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteHealthcareProjectNo)) {
        Write-Host "❌ 'DevSuiteHealthcareProjectNo' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteHealthcareProjectNo' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteMedtecProjectNo)) {
        Write-Host "❌ 'DevSuiteMedtecProjectNo' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteMedtecProjectNo' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteCustomerNo)) {
        Write-Host "❌ 'DevSuiteCustomerNo' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteCustomerNo' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteCustomerName)) {
        Write-Host "❌ 'DevSuiteCustomerName' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteCustomerName' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteProjectManagement)) {
        Write-Host "❌ 'DevSuiteProjectManagement' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteProjectManagement' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteLeadDeveloper)) {
        Write-Host "❌ 'DevSuiteLeadDeveloper' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteLeadDeveloper' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteCostCenter)) {
        Write-Host "❌ 'DevSuiteCostCenter' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'Config.DevSuiteCostCenter' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteBranch)) {
        Write-Host "❌ 'DevSuiteBranch' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteBranch' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteDepartment)) {
        Write-Host "❌ 'DevSuiteDepartment' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteDepartment' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.JiraMedtecProject)) {
        Write-Host "❌ 'JiraMedtecProject' config doesn't exist" 
        $success = $false  
    }
    else {
        Write-Host "✅ 'JiraMedtecProject' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.JiraHealthcareProject)) {
        Write-Host "❌ 'JiraHealthcareProject' config doesn't exist"   
        $success = $false
    }
    else {        
        Write-Host "✅ 'JiraHealthcareProject' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteHealthcareAzureDevOps)) {
        Write-Host "❌ 'DevSuiteHealthcareAzureDevOps' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteHealthcareAzureDevOps' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteHealthcareKUMATarget)) {
        Write-Host "❌ 'DevSuiteHealthcareKUMATarget' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteHealthcareKUMATarget' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteMedtecAzureDevOps)) {
        Write-Host "❌ 'DevSuiteMedtecAzureDevOps' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteMedtecAzureDevOps' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteMedtecAzureDevOps)) {
        Write-Host "❌ 'DevSuiteMedtecAzureDevOps' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteMedtecAzureDevOps' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.DevSuiteMedtecKUMATarget)) {
        Write-Host "❌ 'DevSuiteMedtecKUMATarget' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'DevSuiteMedtecKUMATarget' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.EnvVarDevSuiteBearerToken)) {
        Write-Host "❌ 'EnvVarDevSuiteBearerToken' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'EnvVarDevSuiteBearerToken' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.EnvVarJiraApiToken)) {
        Write-Host "❌ 'EnvVarJiraApiToken' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'EnvVarJiraApiToken' config exist"   
    }

    if ([string]::IsNullOrEmpty($Global:Config.EnvVarAzureDevOpsToken)) {
        Write-Host "❌ 'EnvVarAzureDevOpsToken' config doesn't exist"   
        $success = $false
    }
    else {
        Write-Host "✅ 'EnvVarAzureDevOpsToken' config exist"   
    }   
    return $success               
}
Export-ModuleMember -Function Test-PSDevSupportEnvironment
