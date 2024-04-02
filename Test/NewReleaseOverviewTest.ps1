BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "New-ReleaseOverview.ps1 " {
    Context "when calling New-ReleaseOverview" {
        It "it should create a Excel Sheet " {  
            $result = New-ReleaseOverview -Project "healthcare" -SolutionVersion '24.0'
            $result | Should -BeExactly "https://kvsenavdevfunc001.azurewebsites.net/api/vm?code=PDufc4SwlfmV6rpLn/VPRYuxM0aBbmPaHzvP1sJAfAezpqyWAoLQLQ=="                
        }            
    }       
}