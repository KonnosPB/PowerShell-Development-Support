<#
.SYNOPSIS
This function creates a new environment in DevSuite.

.DESCRIPTION
The New-DevSuite function creates a new environment in DevSuite. It requires several mandatory parameters including project number, project description, project management, customer number, customer name, branch, department, cost center, lead developer, artifact URL, Azure DevOps, and Kuma target.

.PARAMETER ProjectNo
The number of the project. This parameter is mandatory.

.PARAMETER ProjectDescription
The description of the project. This parameter is mandatory.

.PARAMETER ProjectManagement
The management of the project. This parameter is mandatory.

.PARAMETER CustomerNo
The number of the customer. This parameter is mandatory.

.PARAMETER CustomerName
The name of the customer. This parameter is mandatory.

.PARAMETER Branch
The branch for the project. This parameter is mandatory.

.PARAMETER Department
The department for the project. This parameter is mandatory.

.PARAMETER CostCenter
The cost center for the project. This parameter is mandatory.

.PARAMETER LeadDeveloper
The lead developer for the project. This parameter is mandatory.

.PARAMETER ArtifactUrl
The URL for the artifact. This parameter is mandatory.

.PARAMETER AzureDevOps
The Azure DevOps for the project. This parameter is mandatory.

.PARAMETER KumaTarget
The Kuma target for the project. This parameter is mandatory.

.PARAMETER TimeoutMinutes
The timeout in minutes. This parameter is optional. If not provided, the function will default to 45 minutes.

.EXAMPLE
```PowerShell
New-DevSuite -ProjectNo '123' -ProjectDescription 'This is a test project' -ProjectManagement 'John Doe' -CustomerNo '456' -CustomerName 'Test Customer' -Branch 'dev' -Department 'IT' -CostCenter '789' -LeadDeveloper 'Jane Doe' -ArtifactUrl 'http://artifacturl.com' -AzureDevOps 'http://devops.com' -KumaTarget 'test' -TimeoutMinutes 30
```
This example creates a new environment in DevSuite with the provided parameters and a timeout of 30 minutes.
#>
function New-DevSuite {
    Param (
        [Parameter(Mandatory = $true)]
        [string] $ProjectNo,
        [Parameter(Mandatory = $true)]
        [string] $ProjectDescription,
        [Parameter(Mandatory = $true)]
        [string] $ProjectManagement,
        [Parameter(Mandatory = $true)]
        [string] $CustomerNo,
        [Parameter(Mandatory = $true)]
        [string] $CustomerName,
        [Parameter(Mandatory = $true)]
        [string] $Branch,
        [Parameter(Mandatory = $true)]
        [string] $Department,        
        [Parameter(Mandatory = $true)]
        [string] $CostCenter,
        [Parameter(Mandatory = $true)]
        [string] $LeadDeveloper,
        [Parameter(Mandatory = $true)]
        [string] $ArtifactUrl,
        [Parameter(Mandatory = $true)]
        [string] $AzureDevOps,
        [Parameter(Mandatory = $true)]
        [string] $KumaTarget,
        [Parameter(Mandatory = $false)]
        [int] $TimeoutMinutes = 120
    )
    #Check if devsuite already exist
    $newDevSuiteObj = Get-DevSuiteEnvironment -DevSuite $ProjectDescription
    if ($newDevSuiteObj){
        Write-Host "DevSuite '$ProjectDescription' already exist. Skip creating a new one"    
        return $newDevSuiteObj
    }
         
    Write-Host "Creating new devsuite '$ProjectDescription' with artifact url '$artifactUrl'" -ForegroundColor Green

    $jsonObject = @{
        "projectNumber"      = $ProjectNo
        "projectDescription" = $ProjectDescription
        "projectManager"     = $ProjectManagement
        "leadDeveloper"      = $LeadDeveloper
        "branch"             = $Branch
        "customerName"       = $CustomerName
        "customerNumber"     = $CustomerNo
        "department"         = $Department
        "costCenter"         = $CostCenter
        "artifactUrl"        = $ArtifactUrl
        "linkDevOps"         = $AzureDevOps
        "linkKumaTarget"     = $KumaTarget
    } | ConvertTo-Json

    $uri = Get-DevSuiteUri -Route 'vm'
    #Start-Job -ScriptBlock {

    $response = Invoke-DevSuiteWebRequest -Uri $uri -Method POST  -Body $jsonObject
    if (-not ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300)) {        
        throw "Error occured with $response.StatusCode $($script:result.StatusDescription) $($script:result.StatusDescription)"        
    }
    #} | Out-Null

    # Startzeit festlegen
    $startTime = Get-Date

    # Schleife, die bis zu 45 Minuten läuft
    while ((Get-Date) - $startTime -lt [TimeSpan]::FromMinutes($TimeoutMinutes)) {    
        $elapsedTime = (Get-Date) - $startTime
        $minutes = [math]::Truncate($elapsedTime.TotalMinutes)        
        $percentComplete = ($minutes / $TimeoutMinutes * 100)
        Write-Progress -Activity "Waiting for $minutes/$TimeoutMinutes minutes" -Status "Timeout $($percentComplete.ToString("F2"))%" -PercentComplete $percentComplete
        if (Test-DevSuiteEnvironment -DevSuite $ProjectDescription ) {   
            Write-Host "Devsuite '$ProjectDescription' created. Waiting now for tenants" -ForegroundColor Green                     
            Wait-DevSuiteTenantsReady -DevSuite $ProjectDescription -TimeoutMinutes $TimeoutMinutes
            Write-Host "Tenants of devsuite '$ProjectDescription' also ready" -ForegroundColor Green         
            return $devSuite            
        }    
        Start-Sleep -Seconds 30
    }    

    throw "Timeout creating new devsuite '$ProjectDescription'!"
}
Export-ModuleMember -Function  New-DevSuite