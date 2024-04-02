function Invoke-AzureDevOpsWebRequest{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Uri,      
        [Parameter(Mandatory=$true)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string] $Method,      
        [Parameter(Mandatory=$true)]
        [string] $AzureDevOpsToken,
        [Parameter(Mandatory=$false)]
        [switch] $SkipErrorHandling
    )

    $authHeaders = @{ Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$AzureDevOpsToken")))" }

    Write-Host "$($MyInvocation.InvocationName) : Invoke-AzureDevOpsWebRequest -Uri $Uri -Method $Method -Headers $($authHeaders | ConvertTo-Json)"  -NoNewline  
    $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders    
    
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