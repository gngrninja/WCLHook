[cmdletbinding()]
param(
    [Parameter(

    )]
    [switch]
    $StartJob,

    [Parameter(

    )]
    [switch]
    $GetJobInfo,

    [Parameter(

    )]
    [switch]
    $StopJob 
)

$name = "WCL Log Check"

if ($StartJob) {

    Write-Output "Attempting to start job..."

    $curJobInfo = Get-Job -Name $name -ErrorAction SilentlyContinue

    if (!($curJobInfo) -or $curJobInfo.State -ne 'Running') {

        Write-Output ($curJobInfo | Out-String)

        $job = [scriptblock]::Create("$PSScriptRoot\job.ps1")
        Start-Job -Name $name -ArgumentList "$PSScriptRoot" -ScriptBlock $job

    } else {

        Write-Host "Job already started!"

    }

}

if ($GetJobInfo) {

    $info = Receive-Job -Name $name
    Write-Host ($info | Out-String)

}

if ($StopJob) {

    $job = Get-Job -Name $name -ErrorAction SilentlyContinue

    if ($job) {

        Write-Output "Stopping job..."

        $job | Stop-Job
        $job | Remove-Job 

    } else {

        Write-Output "Job not started!"

    }
}