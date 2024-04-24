
BeforeAll {
    . (Join-Path $PSScriptRoot '_InitTest.ps1')    
    # if (-not (Test-DevSuiteBearerToken -BearerToken $Global:DevSuiteBearerToken)){
    #     Update-DevSuiteBearerToken -BearerTokenApplication $Global:Config.BearerTokenApplicationPath
    # }
}

Describe "DevSuite " {
    Context "when calling Get-DevSuiteEnvironments" {
        It "should return all dev suites environments" {  
            $result = Get-DevSuiteEnvironments -BearerToken $Global:DevSuiteBearerToken
            $result.Count | Should -BeGreaterThan 0
        }              

        It "should create, migrate and update new dev suites environment" {  
            $oldDevSuiteProjectDescription = 'HC BC23.5 DE Produktentw.'      
            $oldTenant = 'test'      
            $newDevSuiteProjectDescription = 'HC BC24.0 DE Produktentw. KPA'            
            $newTenant = $oldTenant 
            $artifactUrl = 'https://bcartifacts.azureedge.net/sandbox/23.5.16502.16887/de'
            
            $devSuite = New-DevSuiteEnvironment -BearerToken $Global:DevSuiteBearerToken `
                -ProjectNo $Global:Config.DevSuiteMedtecProjectNo `
                -ProjectDescription 'MEDTEC BC24.0 DE Produktentw.' `
                -CustomerNo $Global:Config.DevSuiteCustomerNo `
                -CustomerName $Global:Config.DevSuiteCustomerName `
                -ProjectManagement $Global:Config.DevSuiteProjectManagement `
                -Branch $Global:Config.DevSuiteBranch `
                -Department $Global:Config.DevSuiteDepartment `
                -CostCenter $Global:Config.DevSuiteCostCenter `
                -LeadDeveloper $Global:Config.DevSuiteLeadDeveloper `
                -ArtifactUrl $artifactUrl  `
                -AzureDevOps $Global:Config.DevSuiteMedtecAzureDevOps `
                -KUMATarget $Global:Config.DevSuiteMedtecKUMATarget  | Should -Not -BeNullOrEmpty 
            $devSuite.projectDescription | Should -BeExactly $projectDescription                        

            Wait-DevSuiteTenantsReady -DevSuite $newDevSuiteProjectDescription -BearerToken $Global:DevSuiteBearerToken

            $oldDevSuite = Get-DevSuiteEnvironment -DevSuite $oldDevSuiteProjectDescription -BearerToken $Global:DevSuiteBearerToken
            $oldDevSuite | Should -Not -BeNullOrEmpty
            $newDevSuite = Get-DevSuiteEnvironment -DevSuite $newDevSuiteProjectDescription -BearerToken $Global:DevSuiteBearerToken
            $newDevSuite | Should -Not -BeNullOrEmpty            

            # Invoke-DevSuiteMigrate -SourceResourceGroup $oldDevSuite.resourceGroup `
            #     -SourceDevSuite $oldDevSuite.name `
            #     -SourceTenant $oldTenant `
            #     -DestinationResourceGroup $newDevSuite.resourceGroup `
            #     -DestinationDevSuite $newDevSuite.name `
            #     -DestinationTenant $newTenant `
            #     -BearerToken $Global:DevSuiteBearerToken
            $newTenantObj = Get-DevSuiteTenant -DevSuite $newDevSuite.name -Tenant $newTenant -BearerToken $Global:DevSuiteBearerToken
            $newTenantObj | Should -Not -BeNullOrEmpty   

            # $publishedApp = Install-DevSuiteBCAppPackages -DevSuite $newDevSuite.name `
            #     -Tenant $newTenant `
            #     -AppName "KUMAVISION base" `
            #     -BearerToken $Global:DevSuiteBearerToken
            # $publishedApp | Should -Not -BeNullOrEmpty                  

            $publishedApp = Get-DevSuitePublishedBCAppPackages -DevSuite $newDevSuite.name `
                -Tenant $newTenant `
                -BearerToken $Global:DevSuiteBearerToken | Where-Object {$_.name -eq "KUMAVISION base" }
                
            $publishedApp | Should -Not -BeNullOrEmpty   

            # Import-DevSuiteLicense -DevSuite $newDevSuite.name `
            #     -LicensePath 'C:\Users\kpapoulas\Downloads\240209 Entwicklerlizenz DE Business Central Produkte V23.bclicense' `
            #     -BearerToken $Global:DevSuiteBearerToken

            #Invoke-DevSuiteCopy -DevSuite  $newDevSuite.name -SourceTenant "test" -DestinationTenant "test2" -BearerToken $Global:DevSuiteBearerToken
            $test2TenantObj = Get-DevSuiteTenant -DevSuite $newDevSuite.name -Tenant "test2" -BearerToken $Global:DevSuiteBearerToken
            $test2TenantObj | Should -Not -BeNullOrEmpty

            # New-DevSuiteUser -DevSuite $newDevSuite.name -Tenant "test" -UserName "foo" -BearerToken $Global:DevSuiteBearerToken
            # Import-DevSuiteTestToolkit -DevSuite $newDevSuite.name -Tenant "test" -BearerToken $Global:DevSuiteBearerToken                             
        }  
    }      
}