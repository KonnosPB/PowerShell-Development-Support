function Invoke-AzureDevOpsWebRequest{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Uri,      
        [Parameter(Mandatory=$true)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string] $Method,      
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsToken,
        [Parameter(Mandatory = $false)]
        [object] $Body,
        [Parameter(Mandatory = $false)]
        [string] $ContentType = 'application/json',
        [Parameter(Mandatory=$false)]
        [switch] $SkipErrorHandling
    )

    $authHeaders = @{ Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$AzureDevOpsToken")))" }

    $callingCommandFile = Split-Path $MyInvocation.PSCommandPath -Leaf | ForEach-Object { $_ -replace '\.[^.]+$', '' }

    if ($Body) {
        $authHeaders.Add("Content-Type", $ContentType)
        Write-Host "$callingCommandFile : Invoke-DevSuiteWebRequest -Uri $Uri -Method $Method -Body $Body" -NoNewline  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders -Body $Body  
    }
    else {
        Write-Host "$callingCommandFile : Invoke-DevSuiteWebRequest -Uri $Uri -Method $Method" -NoNewline  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders 
    }        
    
    if ($result.StatusCode -ge 200 -and $result.StatusCode -lt 300){
        Write-Host " ✅"
        return($result);
    }else {
        Write-Host " ❌"
        if (!$SkipErrorHandling){
            throw "$($result.StatusCode) $($result.StatusDescription)" 
        }
    }
}
Export-ModuleMember -Function Invoke-AzureDevOpsWebRequest