$templateFolderPath = "./source"
$templatePnpPath = "./template.pnp"
$templateLibraryUrl = "/Shared Documents/template.pnp"
$totalSites = 10000
$batchSize = 100
$sitePrefix = "bigtest"
$credPath = "./credentials.xml"
$jobs = @()

# Function to get and store credentials if not stored
function Get-Stored-Credential {
    param (
        [string]$credFilePath
    )
    if (-Not (Test-Path -Path $credFilePath)) {
        $cred = Get-Credential
        $spUrl = Read-Host "Enter SharePoint URL"
        $credHash = @{
            Credential = $cred
            SharePointUrl = $spUrl
        }
        $credHash | Export-Clixml -Path $credFilePath
    } else {
        Write-Host "Using stored credentials from $credFilePath"
    }
}
Get-Stored-Credential -credFilePath $credPath

$storedCreds = Import-Clixml -Path $credPath
$cred = $storedCreds.Credential
$spUrl = $storedCreds.SharePointUrl

# Import and connect with creds
Import-Module PnP.PowerShell
Import-Module ThreadJob
Connect-PnPOnline -Url $spUrl -Credentials $cred

# Convert folder and upload to library
Convert-PnPFolderToSiteTemplate -Folder $templateFolderPath -Out $templatePnpPath
Add-PnPFile -Path $templatePnpPath -Folder "Shared Documents"
$fileExists = Get-PnPFile -Url "$templateLibraryUrl" -AsListItem -ErrorAction SilentlyContinue
if ($fileExists -ne $null) {
    Write-Host "Template uploaded successfully to $templateLibraryUrl"
} else {
    Write-Error "Failed to upload template to $templateLibraryUrl"
    exit
}

# Create and run batches of provisioning
for ($i = 0; $i -lt $totalSites; $i += $batchSize) {
    $end = [math]::Min($i + $batchSize, $totalSites)
    $jobs += Start-ThreadJob -ScriptBlock {
        param($start, $end, $sitePrefix, $templateLibraryUrl, $credPath)

        # Re-Import within batches due to multiple instances of PowerShell
        Import-Module PnP.PowerShell
        Import-Module ThreadJob
        $storedCreds = Import-Clixml -Path $credPath
        $cred = $storedCreds.Credential
        $adminEmail = $cred.UserName
        $spUrl = $storedCreds.SharePointUrl
        Connect-PnPOnline -Url $spUrl -Credentials $cred

        for ($j = $start; $j -lt $end; $j++) {
            try {
                $siteNumber = "{0:D4}" -f $j
                $siteUrl = "$spUrl/sites/$sitePrefix$siteNumber"
                $siteTitle = "$sitePrefix $siteNumber"
                $siteDescription = "Site $sitePrefix number $siteNumber"

                Write-Host "Creating site: $siteUrl"
                New-PnPSite -Type CommunicationSite -Url $siteUrl -Owner $adminEmail -Title $siteTitle -Description $siteDescription

                Write-Host "Created site: $siteUrl"
                Connect-PnPOnline -Url $siteUrl -Credentials $cred
                Invoke-PnPSiteTemplate -Path "$spUrl$templateLibraryUrl"
                Write-Host "Created and applied template to site: $sitePrefix$siteNumber"
            } catch {
                Write-Error "Error processing ${siteTitle}: $_"
            }
        }
    } -ArgumentList $i, $end, $sitePrefix, $templateLibraryUrl, $credPath
}

$jobs | ForEach-Object { $_ | Receive-Job -Wait }

# Check job results and output errors
$jobs | ForEach-Object {
    if ($_.State -eq 'Completed') {
        Write-Host "Job $($_.Id) completed successfully."
    } else {
        Write-Error "Job $($_.Id) failed."
    }
    Remove-Job $_
}

Write-Host "Completed Script and Disconnected"
