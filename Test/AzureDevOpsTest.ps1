BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "Azure Devops Test" {
    Context "Get-AzureDevOpsRepositories" {
        It "it should provide the correct jira tickets" {  
            $result = Get-AzureDevOpsRepositories -AzureDevOpsProject $Global:Config.AzureDevOpsHealthcareProject -AzureDevOpsToken $Global:AzureDevOpsToken
            $result.Count | Should -BeGreaterThan 0
        }               
    }    
}