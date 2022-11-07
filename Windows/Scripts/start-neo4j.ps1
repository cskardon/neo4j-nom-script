# Opening statement
Write-Host -ForegroundColor Green -BackgroundColor Black "Starting Neo4j!"

# Version
. .\scripts\version.ps1
. .\scripts\shared-vars.ps1


Write-Host "Setting Java Environment for this session ... " -NoNewline
if (Test-Path env:_JAVA_OPTIONS) {
  Remove-Item env:_JAVA_OPTIONS
}
$env:NEO4J_ACCEPT_LICENSE_AGREEMENT="yes"
$env:JAVA_HOME = $javaJRELocation
$env:PATH = "$($javaJRELocation)\bin;" + $env:PATH
Write-Host "Done!" -ForegroundColor Green

Write-Host "Importing Neo4j Modules ... " -NoNewline
$neo4jModuleLocation = Join-Path $neo4jLocation "bin\Neo4j-Management.psd1"
Import-Module $neo4jModuleLocation
Write-Host "Done!" -ForegroundColor Green

# Start
Invoke-Neo4j console