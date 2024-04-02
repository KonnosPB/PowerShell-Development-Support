function Invoke-JiraWebRequest{
    Param (
        [Parameter(Mandatory=$true)]
        [string] $Uri,      
        [Parameter(Mandatory=$true)]
        [ValidateSet("GET", "POST", "PATCH")]
        [string] $Method,      
        [Parameter(Mandatory=$true)]
        [string] $JiraApiToken,
        [Parameter(Mandatory = $false)]
        [object] $Body,
        [Parameter(Mandatory = $false)]
        [string] $ContentType = 'application/json',
        [Parameter(Mandatory=$false)]
        [switch] $SkipErrorHandling
    )
    $authorizationContent = "$($Global:Config.JiraEMailAddress):$JiraApiToken"
    $basicAuthorizationContent = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($authorizationContent )))"
    $authHeaders = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $authHeaders.Add("Authorization", $basicAuthorizationContent)

    $callingCommandFile = Split-Path $MyInvocation.PSCommandPath -Leaf | ForEach-Object { $_ -replace '\.[^.]+$', '' }

    if ($Body) {
        $authHeaders.Add("Content-Type", $ContentType)
        Write-Host "$callingCommandFile : Invoke-JiraWebRequest -Uri $Uri -Method $Method -Body $Body" -NoNewline  
        $result = Invoke-WebRequest -Uri $Uri -Method $Method -Headers $authHeaders -Body $Body  
    }
    else {
        Write-Host "$callingCommandFile : Invoke-JiraWebRequest -Uri $Uri -Method $Method" -NoNewline  
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
Export-ModuleMember -Function Invoke-JiraWebRequest