BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
}

Describe "Common Functions Test" {
    Context "Get-BusinessCentralArtifactUrl" {
        It "it should provide the correct artefact url" {  
            $result = Get-BusinessCentralArtifactUrl -country 'de' -version '23.5.16502.17900' -Select Closest
            $result | Should -BeExactly 'https://bcartifacts.azureedge.net/sandbox/23.5.16502.17999/de'
        }               
    }    
}