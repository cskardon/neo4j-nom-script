param($Password="", $SslPassword="")

. .\scripts\functions.ps1

if(!(Test-Parameters(@{ Password = $Password; SslPassword = $SslPassword}))){
    break
}

$process = Get-Process -Id $PID | Select-Object -ExpandProperty ProcessName 

Write-Host "Starting Neo4j Instance"
Start-Process $process -ArgumentList "-command .\scripts\start-neo4j.ps1"

Write-Host "`n`nPlease wait for the Neo4j Instance to be running before pressing ENTER to continue." -ForegroundColor Green
$_ = Read-Host

Write-Host "Starting Neo4j Ops Manager Server"
Start-Process $process -ArgumentList "-command .\scripts\start-nom.ps1 -Password $Password -SslPassword $SslPassword"
