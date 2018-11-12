function Invoke-WclApi {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory
        )]
        [string]
        $Url
    )

    try {

        Write-Verbose "Sending request to -> [https://www.warcraftlogs.com:443/v1$($Url)?api_key=$($wclKey)]"
        $Url = "https://www.warcraftlogs.com:443/v1$($Url)?api_key=$($wclKey)"
        $data = Invoke-RestMethod -Uri $Url -Method Get -ContentType 'Application/Json' -ErrorAction Stop

    }
    
    catch {

        $errorMessage = $_.Exception.Message

        Write-Error "Error getting data from the WCL API -> [$errorMessage]!"

    } 

    return $data

}
