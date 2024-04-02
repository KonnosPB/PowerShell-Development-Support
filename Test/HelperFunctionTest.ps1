BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "HelperFunction.ps1 " {
    Context "when calling Get-DevSuiteUri" {
        It "it should provide the correct uri without parameter " {  
            $result = Get-DevSuiteUri -Route "vm"
            $result | Should -BeExactly "https://kvsenavdevfunc001.azurewebsites.net/api/vm?code=PDufc4SwlfmV6rpLn/VPRYuxM0aBbmPaHzvP1sJAfAezpqyWAoLQLQ=="
        }            

        It "it should provide the correct uri with parameter " {  
            $result = Get-DevSuiteUri -Route "vm" -Parameter "Tenant=default"
            $result | Should -BeExactly "https://kvsenavdevfunc001.azurewebsites.net/api/vm?code=PDufc4SwlfmV6rpLn/VPRYuxM0aBbmPaHzvP1sJAfAezpqyWAoLQLQ==&Tenant=default"
        }   
    }   

    Context "when calling Test-DevSuiteBearerToken" {
        It "it should return false with a dummy bearer token" {  
            $result = Test-DevSuiteBearerToken -BearerToken "dummy"            
            $result | Should -BeExactly $false
        }            

        It "it should return true with a valid bearer token" {                         
            $result = Test-DevSuiteBearerToken -BearerToken $Global:DevSuiteBearerToken     # $Global:DevSuiteBearerToken anstelle von $bearerToken würde auch gehen       
            $result | Should -BeExactly $true
        }     
    }
}