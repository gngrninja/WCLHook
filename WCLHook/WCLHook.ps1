using module PSDsHook
[cmdletbinding()]
param(

)

$functions = @( Get-ChildItem -Path "$PSScriptRoot\functions\*.ps1" )

@($functions) | ForEach-Object {

    Try {

        Write-Verbose "Importing function $($_.Name)"
        . $_.FullName

    } Catch {

        Write-Error -Message "Failed to import function $($_.FullName): $_"
        
    }

}

#Get WarcraftLogs Api key from config.json
$wclKey = Get-Content -Path "$PSScriptRoot\config.json" | ConvertFrom-Json | Select-Object -ExpandProperty wclApiKey

#Retive the list of zones
$zones = Get-Zones

$reportUrl = "/reports/guild/ninjabread%20men/destromath/us"

$curLogFile = "$PSScriptRoot\log.json"

while ($true) {

    $result    = $null
    $lastThree = $null
    $curReport = $null

    Write-Verbose "Looking up latest logs..."

    $result    = Invoke-WclApi -Url $reportUrl
    $lastThree = $result | Select-Object -First 3
    $curReport = $result[0]

    if (!(Test-Path -Path $curLogFile -ErrorAction SilentlyContinue)) {
    
        Write-Verbose "Creating [$curLogFile] as it does not exist!"
        $curReport | ConvertTo-Json | Out-File -FilePath $curLogFile
        Invoke-LogInfoSend -Report $curReport
    
    } else {
    
        Write-Verbose "Checking [$curLogFile] against current results..."
    
        $curLogInfo = Get-Content -Path $curLogFile | ConvertFrom-Json
    
        if ($curLogInfo.id -ne $curReport.id) {
    
            Write-Verbose "Exporting current report to the file as the report IDs are different..."
            $curReport | ConvertTo-Json | Out-File -FilePath $curLogFile
            Invoke-LogInfoSend -Report $curLogInfo
    
        }
    }

    Start-Sleep -Seconds 10

}