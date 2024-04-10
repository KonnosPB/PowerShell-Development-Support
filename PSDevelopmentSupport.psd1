#
# Module manifest for module 'PSDevelopmentSupport'
#
# Generated by: Konstantinos Papoulas-Brosch
#
# Generated on: 2024-03-04
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule           = 'PSDevelopmentSupport.psm1'
    
    # Version number of this module.
    ModuleVersion        = '0.4.0'
    
    # Supported PSEditions
    CompatiblePSEditions = 'Core', 'Desktop'
    
    # ID used to uniquely identify this module
    GUID                 = '6d789830-2897-4dfc-b1bd-ace6f855bed9'
    
    # Author of this module
    Author               = 'Konstantinos Papoulas-Brosch'
    
    # Company or vendor of this module
    CompanyName          = 'Konnos PB'
    
    # Copyright statement for this module
    Copyright            = '(c) 2024 KonnosPB. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description          = 'PowerShell module, which makes it easier to work with KUMA environments.'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion    = '7.4.1'
    
    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''
    
    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''
    
    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''
    
    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''
    
    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()
    
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()
    
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = 'Get-DevSuiteUri', 'Invoke-DevSuiteWebRequest', 'Test-DevSuiteBearerToken', 
    'Update-DevSuiteBearerToken', 'New-DevSuiteEnvironment', 'New-DevSuite', 'Test-DevSuiteEnvironment', 
    'Get-DevSuiteEnvironment', 'Get-DevSuiteEnvironments', 'Wait-DevSuiteTenantsReady', 
    'Test-DevSuiteTenantsMounted', 'Get-DevSuiteTenants', 'Get-DevSuiteTenant', 
    'Invoke-DevSuiteMigrate', 'Wait-DevSuiteTenantsReady', 'Install-DevSuiteBCAppPackages', 
    'Get-DevSuiteAvailableBCAppPackages', 'Get-DevSuiteAvailableBCAppPackage', 'Get-DevSuiteAvailableBCAppPackage', 
    'Get-DevSuitePublishedBCAppPackages', 'Import-DevSuiteLicense', 'Invoke-DevSuiteCopy', 
    'New-DevSuiteUser', 'Import-DevSuiteTestToolkit', 'Get-BusinessCentralArtifactUrl', 
    "Get-JiraTicketsFromSolutionVersion", "Get-JiraCompletedTicketsFromSolutionVersion", "Add-JiraTicketsToPullRequests",
    "Get-AzureDevOpsRepositories", "Get-AzureDevOpsMasterBranchPullRequests", "Get-AzureDevOpsPullRequestWorkItems", "Get-AzureDevOpsWorkItemsFromJiraTickets",
    "Test-AzureDevOpsWorkItemMergedIntoDevelop", "New-ReleaseExcelWorksheet", "New-ReleaseOverview", 'Test-PSDevSupportEnvironment', 'Get-DevSuiteBearerToken'
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = '*'
    
    # Variables to export from this module
    VariablesToExport    = '*'
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    # AliasesToExport = '', ''
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    FileList             = @("InitializeModule.ps1", "DevSuite\Get-DevSuiteUri.ps1", "DevSuite\Invoke-DevSuiteWebRequest.ps1", 
        "DevSuite\Test-DevSuiteBearerToken.ps1", "DevSuite\Update-DevSuiteBearerToken.ps1",  "DevSuite\New-DevSuite.ps1",
        "DevSuite\New-DevSuiteEnvironment.ps1", "DevSuite\Test-DevSuiteEnvironment.ps1", 
        "DevSuite\Get-DevSuiteEnvironment.ps1", "DevSuite\Get-DevSuiteEnvironments.ps1", "DevSuite\Wait-DevSuiteTenantsReady.ps1", 
        "DevSuite\Test-DevSuiteTenantsMounted.ps1", "DevSuite\Get-DevSuiteTenants.ps1", "DevSuite\Get-DevSuiteTenant.ps1", 
        "DevSuite\Invoke-DevSuiteMigrate.ps1", "DevSuite\Wait-DevSuiteTenantsReady.ps1", "DevSuite\Install-DevSuiteBCAppPackages.ps1", 
        "DevSuite\Get-DevSuiteAvailableBCAppPackages.ps1", "DevSuite\Get-DevSuiteAvailableBCAppPackage.ps1", "DevSuite\Get-DevSuitePublishedBCAppPackages.ps1", 
        "DevSuite\Import-DevSuiteLicense.ps1", "DevSuite\Invoke-DevSuiteCopy.ps1", "DevSuite\New-DevSuiteUser.ps1", "DevSuite\Import-DevSuiteTestToolkit.ps1", 
        "DevOps\Get-AzureDevOpsUri.ps1", "DevOps\Invoke-AzureDevOpsWebRequest.ps1", "DevOps\Get-AzureDevOpsRepositories.ps1", 
        "DevOps\Get-DevSuiteBearerToken.ps1"
        "DevOps\Get-AzureDevOpsMasterBranchPullRequests.ps1", "DevOps\Get-AzureDevOpsPullRequestWorkItems.ps1", "DevOps\Get-AzureDevOpsWorkItemsFromJiraTickets.ps1",
        "DevOps\Test-AzureDevOpsWorkItemMergedIntoDevelop.ps1",
        "Jira\Get-JiraUri.ps1", "Jira\Invoke-JiraWebRequest.ps1", "Jira\Get-JiraTicketsFromSolutionVersion.ps1", "Jira\Get-JiraCompletedTicketsFromSolutionVersion.ps1", 
        "Jira\Add-JiraTicketsToPullRequests.ps1", "Jira\Add-JiraTicketsToPullRequests.ps1", 
        "Common\New-ReleaseOverview.ps1", "Common\Test-PSDevSupportEnvironment.ps1", "Common\New-ReleaseExcelWorksheet.ps1",
        "Common\Get-BusinessCentralArtifactUrl.ps1" )
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags                     = @('KUMA', 'Development')
    
            # A URL to the license for this module.
            LicenseUri               = 'https://github.com/KonnosPB/PSDevelopementSupport/blob/main/LICENSE'
    
            # A URL to the main website for this project.
            ProjectUri               = 'https://github.com/KonnosPB/PSDevelopementSupport'
    
            # A URL to an icon representing this module.
            IconUri                  = 'https://github.com/KonnosPB/PSDevelopementSupport/blob/main/icon.png'
    
            # ReleaseNotes of this module
            ReleaseNotes             = 'None'
    
            # Prerelease string of this module
            # Prerelease = ''
    
            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $false
    
            # External dependent modules of this module
            # ExternalModuleDependencies = @()
    
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
}