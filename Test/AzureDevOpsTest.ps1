BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "Azure Devops Test" {
    Context "Get-AzureDevOpsRepositories" {
        It "it should provide the correct devops repos" {  
            $result = Get-AzureDevOpsRepositories -AzureDevOpsProject $Global:Config.AzureDevOpsHealthcareProject -AzureDevOpsToken $Global:AzureDevOpsToken
            $result.Count | Should -BeGreaterThan 0
        }               
    }    

    Context "Get-AzureDevOpsMasterBranchPullRequests" {
        It "it should provide the correct devops pull-requests" {  
            $repos = Get-AzureDevOpsRepositories -AzureDevOpsProject $Global:Config.AzureDevOpsHealthcareProject -AzureDevOpsToken $Global:AzureDevOpsToken
            $result = Get-AzureDevOpsMasterBranchPullRequests -AzureDevOpsProject $Global:Config.AzureDevOpsHealthcareProject -AzureDevOpsRepositories $repos -AzureDevOpsToken $Global:AzureDevOpsToken
            $result.Count | Should -BeGreaterThan 0
        }               
    }    
}