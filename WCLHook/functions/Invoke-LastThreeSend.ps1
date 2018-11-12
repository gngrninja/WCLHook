function Invoke-LastThreeSend {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory
        )]
        $Reports
    )

    [System.Collections.ArrayList]$textToSend = @()

    foreach ($report in $Reports) {

        $reportUrl = $null
        $zone      = $null
        $startTime = $null
        $endTime   = $null

        $zone      = $zones | Where-Object {$report.zone -eq $_.id} | Select-Object -ExpandProperty name
        $startTime = Convert-FromUnixTimeMili -Time $report.start
        $endTime   = Convert-FromUnixTimeMili -Time $report.end
        $reportUrl = "https://www.warcraftlogs.com/reports/$($report.id)"

        $text = @"
[__**$($report.title)**__ *$zone*]($reportUrl)
Start :clock: [**$startTime**]    
End   :clock: [**$endTime**]      
[WoWAnalyzer](https://wowanalyzer.com/report/$($report.id)) | :sob: [WipeFest](https://www.wipefest.net/report/$($report.id))

"@
        $textToSend.Add($text) | Out-Null
     }
    
    $embedBuilder = [DiscordEmbed]::New(
                'Logs for Ninjabread Men on Destromath',
                ($textToSend | Out-String)
    )

    Invoke-PSDsHook -EmbedObject $embedBuilder

}
