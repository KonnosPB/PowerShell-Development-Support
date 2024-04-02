BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "JIRA Test" {
    Context "Get-JiraTicketsFromSolutionVersion" {
        It "it should provide the correct jira tickets" {  
            $result = Get-JiraTicketsFromSolutionVersion -JiraProject $Global:Config.JiraHealthcareProject -Version '23.5' -JiraApiToken $Global:JiraApiToken
            $result.Count | Should -BeGreaterThan 0
        }               
    }    
}