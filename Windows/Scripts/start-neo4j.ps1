# Opening statement
Write-Host -ForegroundColor Green -BackgroundColor Black "Starting Neo4j!"

# Version
. .\scripts\version.ps1
. .\scripts\shared-vars.ps1

Write-Host "Setting Java Environment for this session ... " -NoNewline
. .\scripts\environment-java-17.ps1
Write-Host " Done!" -ForegroundColor Green
$env:NEO4J_ACCEPT_LICENSE_AGREEMENT="yes"

Write-Host "Importing Neo4j Modules ... " -NoNewline
$neo4jModuleLocation = Join-Path $neo4jLocation "bin\Neo4j-Management.psd1"
Import-Module $neo4jModuleLocation
Write-Host "Done!" -ForegroundColor Green

# Start
Invoke-Neo4j console