 <#
 "BaseMedtecBcApps" : [
        "KUMAVISION Core",
        "KUMAVISION base",
        "KUMAVISION base DACH", 
        "Quality Management", 
        "DMS and ECM Interface"        
    ],
    "KumaConnectMedtecBcApps" : [
        "KUMAVISION Core",
        "KUMAVISION base",
        "KUMAVISION base DACH", 
        "Quality Management", 
        "KUMAconnect"
    ],
    "BaseHealthcareBcApps" : [
        "KUMAVISION Core",
        "KUMAVISION base",
        "KUMAVISION base DACH", 
        "Continia OPplus",
        "Quality Management", 
        "DMS and ECM Interface"        
    ],
    "KumaConnectHealthcareBcApps" : [
        "KUMAVISION Core",
        "KUMAVISION base",
        "KUMAVISION base DACH", 
        "Continia OPplus",
        "Quality Management", 
        "KUMAconnect"
    ]
#>

$apps = @("Quality Management", "KUMAconnect")
Install-DevSuiteBCAppPackages -InstallApps $apps -DevSuite "KVSENAVDEV508" -Tenant "test-kumaconnect"