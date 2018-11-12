function Invoke-LogInfoSend {
    [cmdletbinding()]
    param(
        $Report
    )

    #Get the zone name the log takes place in
    $zone = $zones | 
        Where-Object {
            $Report.zone -eq $_.id
        } | 
        Select-Object -ExpandProperty name

    $startTime = Convert-FromUnixTimeMili -Time $Report.start
    $endTime   = Convert-FromUnixTimeMili -Time $Report.end
    $reportUrl = "https://www.warcraftlogs.com/reports/$($Report.id)"

    $text = @"
    [__**$($Report.title)**__ *$zone*]($reportUrl)
    Start :clock: [**$startTime**]    
    End   :clock: [**$endTime**]         
"@

    
    $embedBuilder = [DiscordEmbed]::New(
        'Logs for Ninjabread Men on Destromath',
        ($text | Out-String)
    )

    $embedBuilder.AddField(
        [DiscordField]::New(
            'Detailed Information',
            @"
            :mag: [WoWAnalyzer](https://wowanalyzer.com/report/$($Report.id))
            :sob: [WipeFest](https://www.wipefest.net/report/$($Report.id))
"@
        ))

    Invoke-PSDsHook -EmbedObject $embedBuilder

}
