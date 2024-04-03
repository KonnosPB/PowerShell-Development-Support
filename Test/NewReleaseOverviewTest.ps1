BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "New-ReleaseOverview.ps1 " {
    Context "when calling New-ReleaseOverview" {
        It "it should create a Excel Sheet " {  
            New-ReleaseOverview -Project "healthcare" -JiraSolutionVersion '24.0'
        }            
    }       
}