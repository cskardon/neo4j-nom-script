param($Password="")

# Opening statement
Write-Host "Changing Settings..."

# Version
. .\scripts\version.ps1
. .\scripts\shared-vars.ps1
. .\scripts\functions.ps1

if(!(Test-Parameters(@{ Password = $Password}))){
    break
}

# Directories
$neo4jLocation = Join-Path (Get-Location).Path "neo4j-enterprise-$($neo4jVersion)"
$javaJRELocation = Join-Path (Get-Location).Path "jdk-$($temurinHomeVersion)-jre"

# Configurationfile
$configFileLocation = Join-Path $neo4jLocation "conf\neo4j.conf"

#Add all the config you want here, newlines are added later.
$configLines = (
    "server.metrics.enabled=true",
    "server.metrics.filter=*",
    "server.metrics.csv.enabled=false",
    "server.metrics.graphite.enabled=false",
    "server.metrics.jmx.enabled=true",

    "server.default_listen_address=0.0.0.0",
    "server.memory.heap.initial_size=512m",
    "server.memory.heap.max_size=512m",
    "server.memory.pagecache.size=512m",
    "dbms.memory.transaction.total.max=2000m",
    "db.tx_log.rotation.retention_policy=1G size",
    "dbms.db.timezone=SYSTEM",
    "browser.remote_content_hostname_whitelist=*",

    "db.logs.query.enabled=OFF",
    "db.logs.query.threshold=0",
    "db.logs.query.parameter_logging_enabled=true",

    "server.bolt.listen_address=:$nomNeo4jBoltPort",
    "server.bolt.advertised_address=:$nomNeo4jBoltPort",
    "server.http.listen_address=:$nomNeo4jHttpPort",
    "server.http.advertised_address=:$nomNeo4jHttpPort",
    "server.backup.listen_address=0.0.0.0:$nomNeo4jBackupPort",
    "server.discovery.listen_address=:$nomNeo4jServerDiscoveryPort",
    "server.discovery.advertised_address=:$nomNeo4jServerDiscoveryPort"
)

Write-Host "Adding config to " $configFileLocation
foreach($line in $configLines) {
    #Add-Content -Path $configFileLocation -Value "`r`n$($line)"
    Add-Content -Path $configFileLocation -Value "$($line)"
    Write-Host "`t *" $line
}
Write-Host "Done!" -ForegroundColor Green

Write-Host "Setting Java Environment for this session ... " -NoNewline
$env:JAVA_HOME = $javaJRELocation
$env:PATH = "$($javaJRELocation)\bin;" + $env:PATH
Write-Host "Done!" -ForegroundColor Green

Write-Host "Importing Neo4j Modules ... " -NoNewline
$neo4jModuleLocation = Join-Path $neo4jLocation "bin\Neo4j-Management.psd1"
Import-Module $neo4jModuleLocation
Write-Host "Done!" -ForegroundColor Green

Write-Host "Setting neo4j initial password ... " -NoNewline
Invoke-Neo4jAdmin dbms set-initial-password $password
Write-Host "Done!" -ForegroundColor Green

# All done
Write-Host "`nSettings Complete" -ForegroundColor Green
