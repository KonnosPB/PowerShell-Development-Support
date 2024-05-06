<# 
 .Synopsis
  Get a list of available artifact URLs
 .Description
  Get a list of available artifact URLs.  It can be used to create a new instance of a Container.
 .Parameter type
  OnPrem or Sandbox (default is Sandbox)
 .Parameter country
  the requested localization of Business Central
 .Parameter version
  The version of Business Central (will search for entries where the version starts with this value of the parameter)
 .Parameter select
  All or only the latest (Default Latest):
    - All: will return all possible urls in the selection.
    - Latest: will sort on version, and return latest version.
    - Daily: will return the latest build from yesterday (ignoring builds from today). Daily only works with Sandbox artifacts.
    - Weekly: will return the latest build from last week (ignoring builds from this wwek). Weekly only works with Sandbox artifacts.
    - Closest: will return the closest version to the version specified in version (must be a full version number).
    - SecondToLastMajor: will return the latest version where Major version number is second to Last (used to get Next Minor version from insider).
    - Current: will return the currently active sandbox release.
    - NextMajor: will return the next major sandbox release (will return empty if no Next Major is available).
    - NextMinor: will return the next minor sandbox release (will return NextMajor when the next release is a major release).
 .Parameter storageAccount
  The storageAccount that is being used where artifacts are stored (default is bcartifacts, usually should not be changed).
 .Parameter sasToken
  OBSOLETE - sasToken is no longer supported
 .Parameter accept_insiderEula
  Accept the EULA for Business Central Insider artifacts. This is required for using Business Central Insider artifacts without providing a SAS token after October 1st 2023.
 .Example
  Get the latest URL for Belgium: 
  Get-BusinessCentralArtifactUrl -Type OnPrem -Select Latest -country be
  
  Get all available Artifact URLs for BC SaaS:
  Get-BusinessCentralArtifactUrl -Type Sandbox -Select All
#>
function Get-BusinessCentralArtifactUrl {
    [CmdletBinding()]
    param (
        [ValidateSet('OnPrem', 'Sandbox')]
        [String] $Type = 'Sandbox',
        [String] $Country = '',
        [String] $Version = '',
        [ValidateSet('Latest', 'First', 'All', 'Closest', 'SecondToLastMajor', 'Current', 'NextMinor', 'NextMajor', 'Daily', 'Weekly')]
        [String] $select = 'Latest',
        [DateTime] $after,
        [DateTime] $before,
        [String] $storageAccount = '',
        [Obsolete("sasToken is no longer supported")]
        [String] $sasToken = '',
        [switch] $accept_insiderEula,
        [switch] $doNotCheckPlatform
    )

    if ($Type -eq "OnPrem") {
        if ($Version -like '18.9*') {
            Write-Host -ForegroundColor Yellow 'On-premises build for 18.9 was replaced by 18.10.35134.0, using this version number instead'
            $Version = '18.10.35134.0'
        }
        elseif ($Version -like '17.14*') {
            Write-Host -ForegroundColor Yellow 'On-premises build for 17.14 was replaced by 17.15.35135.0, using this version number instead'
            $Version = '17.15.35135.0'
        }
        elseif ($Version -like '16.18*') {
            Write-Host -ForegroundColor Yellow 'On-premises build for 16.18 was replaced by 16.19.35126.0, using this version number instead'
            $Version = '16.19.35126.0'
        }
        if ($Select -eq "Weekly" -or $Select -eq "Daily") {
            $Select = 'Latest'
        }
    }

    if ($Select -eq "Weekly" -or $Select -eq "Daily") {
        if ($Select -eq "Daily") {
            $ignoreBuildsAfter = [DateTime]::Today
        }
        else {
            $ignoreBuildsAfter = [DateTime]::Today.AddDays( - [datetime]::Today.DayOfWeek)
        }
        if ($Version -ne '' -or ($After) -or ($Before)) {
            throw 'You cannot specify version, before or after  when selecting Daily or Weekly build'
        }
        $current = Get-BusinessCentralArtifactUrl -country $Country -select Latest -doNotCheckPlatform:$DoNotCheckPlatform
        Write-Verbose "Current build is $current"
        if ($current) {
            $currentversion = [System.Version]($current.Split('/')[4])
            $periodic = Get-BusinessCentralArtifactUrl -country $Country -select Latest -doNotCheckPlatform:$DoNotCheckPlatform -before ($ignoreBuildsAfter.ToUniversalTime()) -version "$($currentversion.Major).$($currentversion.Minor)"
            if (-not $periodic) {
                $periodic = Get-BusinessCentralArtifactUrl -country $Country -select First -doNotCheckPlatform:$DoNotCheckPlatform -after ($ignoreBuildsAfter.ToUniversalTime()) -version "$($currentversion.Major).$($currentversion.Minor)"
            }
            Write-Verbose "Periodic build is $periodic"
            if ($periodic) { $current = $periodic }
        }
        $current
    }
    elseif ($Select -eq "Current") {
        if ($StorageAccount -ne '' -or $Type -eq 'OnPrem' -or $Version -ne '') {
            throw 'You cannot specify storageAccount, type=OnPrem or version when selecting Current release'
        }
        Get-BusinessCentralArtifactUrl -country $Country -select Latest -doNotCheckPlatform:$DoNotCheckPlatform
    }
    elseif ($Select -eq "NextMinor" -or $Select -eq "NextMajor") {
        if ($StorageAccount -ne '' -or $Type -eq 'OnPrem' -or $Version -ne '') {
            throw "You cannot specify storageAccount, type=OnPrem or version when selecting $Select release"
        }

        $current = Get-BusinessCentralArtifactUrl -country 'base' -select Latest -doNotCheckPlatform:$DoNotCheckPlatform
        $currentversion = [System.Version]($current.Split('/')[4])

        $nextminorversion = "$($currentversion.Major).$($currentversion.Minor+1)."
        $nextmajorversion = "$($currentversion.Major+1).0."
        if ($currentVersion.Minor -ge 5) {
            $nextminorversion = $nextmajorversion
        }

        if (-not $Country) { $Country = 'w1' }
        $insiders = Get-BusinessCentralArtifactUrl -country $Country -storageAccount bcinsider -select All -sasToken $SasToken -doNotCheckPlatform:$DoNotCheckPlatform -accept_insiderEula:$Accept_InsiderEula
        $nextmajor = $insiders | Where-Object { $_.Split('/')[4].StartsWith($nextmajorversion) } | Select-Object -Last 1
        $nextminor = $insiders | Where-Object { $_.Split('/')[4].StartsWith($nextminorversion) } | Select-Object -Last 1

        if ($Select -eq 'NextMinor') {
            $nextminor
        }
        else {
            $nextmajor
        }
    }
    else {
        if ($SasToken) {
            TestSasToken -url $SasToken
        }

        if ($StorageAccount -eq '') {
            $StorageAccount = 'bcartifacts'
        }

        if (-not $storageAccount.Contains('.')) {
            $storageAccount += ".blob.core.windows.net"
        }
        $BaseUrl = ReplaceCDN -sourceUrl "https://$storageAccount/$($Type.ToLowerInvariant())/" -useBlobUrl:($bcContainerHelperConfig.DoNotUseCdnForArtifacts)
        $storageAccount = ReplaceCDN -sourceUrl $storageAccount -useBlobUrl

        if ($storageAccount -eq 'bcinsider.blob.core.windows.net' -and !$accept_insiderEULA) {
            throw "You need to accept the insider EULA (https://go.microsoft.com/fwlink/?linkid=2245051) by specifying -accept_insiderEula or by providing a SAS token to get access to insider builds"
        }
        $GetListUrl = "https://$storageAccount/$($Type.ToLowerInvariant())/?comp=list&restype=container"
    
        $upMajorFilter = ''
        $upVersionFilter = ''
        if ($Select -eq 'SecondToLastMajor') {
            if ($Version) {
                throw "You cannot specify a version when asking for the Second To Last Major version"
            }
        }
        elseif ($Select -eq 'Closest') {
            if (!($Version)) {
                throw "You must specify a version number when you want to get the closest artifact Url"
            }
            $dots = ($Version.ToCharArray() -eq '.').Count
            $closestToVersion = [Version]"0.0.0.0"
            if ($dots -ne 3 -or !([Version]::TryParse($Version, [ref] $closestToVersion))) {
                throw "Version number must be in the format 1.2.3.4 when you want to get the closes artifact Url"
            }
            $GetListUrl += "&prefix=$($closestToVersion.Major).$($closestToVersion.Minor)."
            $upMajorFilter = "$($closestToVersion.Major)"
            $upVersionFilter = "$($closestToVersion.Minor)."
        }
        elseif (!([string]::IsNullOrEmpty($Version))) {
            $dots = ($Version.ToCharArray() -eq '.').Count
            if ($dots -lt 3) {
                # avoid 14.1 returning 14.10, 14.11 etc.
                $Version = "$($Version.TrimEnd('.'))."
            }
            $GetListUrl += "&prefix=$($Version)"
            $upMajorFilter = $Version.Split('.')[0]
            $upVersionFilter = $Version.Substring($Version.Length).TrimStart('.')
        }

        $Artifacts = @()
        $nextMarker = ''
        $currentMarker = ''
        $downloadAttempt = 1
        $downloadRetryAttempts = 10
        do {
            if ($currentMarker -ne $nextMarker)
            {
                $currentMarker = $nextMarker
                $downloadAttempt = 1
            }
            Write-Verbose "Download String $GetListUrl$nextMarker"
            try
            {
                $Response = Invoke-RestMethod -UseBasicParsing -ContentType "application/json; charset=UTF8" -Uri "$GetListUrl$nextMarker"
                if (([int]$Response[0]) -eq 239 -and ([int]$Response[1]) -eq 187 -and ([int]$Response[2]) -eq 191) {
                    # Remove UTF8 BOM
                    $response = $response.Substring(3)
                }
                if (([int]$Response[0]) -eq 65279) {
                    # Remove Unicode BOM (PowerShell 7.4)
                    $response = $response.Substring(1)
                }
                $enumerationResults = ([xml]$Response).EnumerationResults

                if ($enumerationResults.Blobs) {
                    if (($After) -or ($Before)) {
                        $artifacts += $enumerationResults.Blobs.Blob | % {
                            if ($after) {
                                $blobModifiedDate = [DateTime]::Parse($_.Properties."Last-Modified")
                                if ($before) {
                                    if ($blobModifiedDate -lt $before -and $blobModifiedDate -gt $after) {
                                        $_.Name
                                    }
                                }
                                elseif ($blobModifiedDate -gt $after) {
                                    $_.Name
                                }
                            }
                            else {
                                $blobModifiedDate = [DateTime]::Parse($_.Properties."Last-Modified")
                                if ($blobModifiedDate -lt $before) {
                                    $_.Name
                                }
                            }
                        }
                    }
                    else {
                        $artifacts += $enumerationResults.Blobs.Blob.Name
                    }
                }
                $nextMarker = $enumerationResults.NextMarker
                if ($nextMarker) {
                    $nextMarker = "&marker=$nextMarker"
                }
            }
            catch
            {
                $downloadAttempt += 1
                Write-Host "Error querying artifacts. Error message was $($_.Exception.Message)"
                Write-Host

                if ($downloadAttempt -le $downloadRetryAttempts)
                {
                    Write-Host "Repeating download attempt (" $downloadAttempt.ToString() " of " $downloadRetryAttempts.ToString() ")..."
                    Write-Host
                }
                else
                {
                    throw
                }                
            }
        } while ($nextMarker)

        if (!([string]::IsNullOrEmpty($country))) {
            # avoid confusion between base and se
            $countryArtifacts = $Artifacts | Where-Object { $_.EndsWith("/$country", [System.StringComparison]::InvariantCultureIgnoreCase) -and ($doNotCheckPlatform -or ($Artifacts.Contains("$($_.Split('/')[0])/platform"))) }
            if (!$countryArtifacts) {
                if (($type -eq "sandbox") -and ($bcContainerHelperConfig.mapCountryCode.PSObject.Properties.Name -eq $country)) {
                    $country = $bcContainerHelperConfig.mapCountryCode."$country"
                    $countryArtifacts = $Artifacts | Where-Object { $_.EndsWith("/$country", [System.StringComparison]::InvariantCultureIgnoreCase) -and ($doNotCheckPlatform -or ($Artifacts.Contains("$($_.Split('/')[0])/platform"))) }
                }
            }
            $Artifacts = $countryArtifacts
        }
        else {
            $Artifacts = $Artifacts | Where-Object { !($_.EndsWith("/platform", [System.StringComparison]::InvariantCultureIgnoreCase)) }
        }

        switch ($Select) {
            'All' {  
                $Artifacts = $Artifacts |
                    Sort-Object { [Version]($_.Split('/')[0]) }
            }
            'Latest' { 
                $Artifacts = $Artifacts |
                    Sort-Object { [Version]($_.Split('/')[0]) } |
                    Select-Object -Last 1
            }
            'First' { 
                $Artifacts = $Artifacts |
                    Sort-Object { [Version]($_.Split('/')[0]) } |
                    Select-Object -First 1
            }
            'SecondToLastMajor' { 
                $Artifacts = $Artifacts |
                    Sort-Object -Descending { [Version]($_.Split('/')[0]) }
                $latest = $Artifacts | Select-Object -First 1
                if ($latest) {
                    $latestversion = [Version]($latest.Split('/')[0])
                    $Artifacts = $Artifacts |
                        Where-Object { ([Version]($_.Split('/')[0])).Major -ne $latestversion.Major } |
                        Select-Object -First 1
                }
                else {
                    $Artifacts = @()
                }
            }
            'Closest' {
                $Artifacts = $Artifacts |
                    Sort-Object { [Version]($_.Split('/')[0]) }
                $closest = $Artifacts |
                    Where-Object { [Version]($_.Split('/')[0]) -ge $closestToVersion } |
                    Select-Object -First 1
                if (-not $closest) {
                    $closest = $Artifacts | Select-Object -Last 1
                }
                $Artifacts = $closest           
            }
        }
    
        foreach ($Artifact in $Artifacts) {
            "$BaseUrl$($Artifact)$SasToken"
        }
    }

}
Export-ModuleMember -Function Get-BusinessCentralArtifactUrl