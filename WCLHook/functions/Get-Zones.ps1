function Get-Zones {
    [cmdletbinding()]
    param(
        
    )

    $zoneUrl = '/zones'

    $zones = Invoke-WclApi -Url $zoneUrl

    return $zones

}
