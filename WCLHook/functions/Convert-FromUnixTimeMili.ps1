function Convert-FromUnixTimeMili {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory
        )]
        [long]
        $Time
    )

    $start = Get-Date -Day 1 -Month 1 -Year 1970

    $returnTime = $start.AddMilliseconds($Time)

    return $returnTime

}
