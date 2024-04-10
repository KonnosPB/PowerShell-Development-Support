function New-DevSuiteEnvironment {
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Healtcare", "Medtech")]
        [string] $Solution,
        [Parameter(Mandatory = $true)]
        [string] $Version,
        [Parameter(Mandatory = $true)]
        [string] $NewDevSuite,
        [Parameter(Mandatory = $true)]
        [string] $MigrationDevSuite,
        [Parameter(Mandatory = $true)]
        [string] $MigrationTenant,
        [Parameter(Mandatory = $true)]        
        [string] $LicensePath,
        [Parameter(Mandatory = $false)]
        [string[]] $Users = @("kuma", "kuma1", "kuma2", "kuma3", "kuma4", "kuma5"),
        [Parameter(Mandatory = $false)]
        [string[]] $ExternalApps = @("Quality Management", "KUMAVISION base", "KUMAVISION base"),
        [Parameter(Mandatory = $false)]
        [string[]] $ExternalPreviewApps = @(),
        [Parameter(Mandatory = $false)]
        [switch] $SkipCreation,
        [Parameter(Mandatory = $false)]
        [switch] $SkipMigration,
        [Parameter(Mandatory = $false)]
        [switch] $SkipCronus
    )

    $script:ArtefactUrl = Get-BusinessCentralArtifactUrl -Country "de" -Version $version -Select Latest -Type Sandbox
    if ($Solution = -eq "Medtech") {
        $script:ProjectNo = $Global:Config.DevSuiteMedtecProjectNo
        $script:AzureDevOps = $Global:Config.DevSuiteMedtecAzureDevOps
        $script:KUMATarget = $Global:Config.DevSuiteMedtecKUMATarget
    }
    else {
        $script:ProjectNo = $Global:Config.DevSuiteHealthcareProjectNo
        $script:AzureDevOps = $Global:Config.DevSuiteHealthcareAzureDevOps
        $script:KUMATarget = $Global:Config.DevSuiteHealthcareKUMATarget
    }

    if (-not $SkipCreation.IsPresent) {
        New-DevSuite `
            -ProjectNo $script:ProjectNo `
            -ProjectDescription $NewDevSuite `
            -CustomerNo $Global:Config.DevSuiteCustomerNo `
            -CustomerName $Global:Config.DevSuiteCustomerName `
            -ProjectManagement $Global:Config.DevSuiteProjectManagement `
            -Branch $Global:Config.DevSuiteBranch `
            -Department $Global:Config.DevSuiteDepartment `
            -CostCenter $Global:Config.DevSuiteCostCenter `
            -LeadDeveloper $Global:Config.DevSuiteLeadDeveloper `
            -ArtifactUrl $script:ArtefactUrl  `
            -AzureDevOps $script:ProjectNo =  $script:AzureDevOps `
            -KUMATarget $script:KUMATarget 
    }

    if (-not $SkipMigration.IsPresent) {
        # Neue DevSuite object beschaffen        
        $newDevSuiteObj = Get-DevSuiteEnvironment -NameOrDescription $NewDevSuite     
        if (-not $newDevSuiteObj) {
            throw "DevSuite '$NewDevSuite' konnte nicht erfolgreich angelegt werden."
        }    

        # Migrations DevSuite object beschaffen
        $migrationDevSuite = Get-DevSuiteEnvironment -NameOrDescription $MigrationDevSuite
        if (-not $migrationDevSuite) {
            throw "DevSuite '$MigrationDevSuite' nicht gefunden."
        }     

        Invoke-DevSuiteMigrate -SourceResourceGroup $migrationDevSuite.resourceGroup `
            -SourceDevSuite $migrationDevSuite.name `
            -SourceTenant $testTenantName `
            -DestinationResourceGroup $newDevSuite.resourceGroup `
            -DestinationDevSuite $newDevSuiteDescription `
            -DestinationTenant $testTenantName
    }

    # Installation App in test-Tenant
    Install-DevSuiteBCAppPackages `
        -AppNames $ExternalApps `
        -Preview $ExternalPreviewApps `
        -Tenant $MigrationTenant `
        -DevSuite $NewDevSuite

    foreach ($User in $Users){
        New-DevSuiteUser -UserName $User -DevSuite $NewDevSuite -Tenant $MigrationTenant -ErrorAction SilentlyContinue
    }

    # cronusag tenant anlegen
    if (-not $SkipCronus){
        Invoke-DevSuiteCopy -DevSuite $NewDevSuite -SourceTenant "default" -DestinationTenant "cronusag"
    }    
}
Export-ModuleMember -Function  New-DevSuiteEnvironment