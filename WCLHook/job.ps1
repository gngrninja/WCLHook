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

#Construct report URL based on guild and realm name
$reportUrl = "/reports/guild/ninjabread%20men/destromath/us"

#Set path to the log info export file (used to see if there is a new log)
$curLogFile = "$PSScriptRoot\log.json"

Invoke-LogCheck