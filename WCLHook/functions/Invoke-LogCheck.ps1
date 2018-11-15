function Invoke-LogCheck {
    [cmdletbinding()]
    param(

    )
    $i = 0
    while ($true) {

        $result    = $null
        $curReport = $null
    
        Write-Verbose "Looking up latest logs..."
    
        $result    = Invoke-WclApi -Url $reportUrl
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
    
        $i++
        Start-Sleep -Seconds 10
        Write-Output "Log check has run [$i] times!"
        
    }
}