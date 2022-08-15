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
$javaJRELocation = Join-Path (Get-Location).Path "zulu$($zuluVersion)-ca-jre$($jreVersion)-win_x64"

# Configurationfile
$configFileLocation = Join-Path $neo4jLocation "conf\neo4j.conf"

#Add all the config you want here, newlines are added later.
$configLines = (
    "metrics.enabled=true",
    "metrics.namespaces.enabled=true",
    "metrics.filter=*",     
    "metrics.csv.enabled=false",
    # "metrics.prometheus.enabled=true",
    # "metrics.prometheus.endpoint=0.0.0.0:2004",
    "metrics.graphite.enabled=false",
    "metrics.jmx.enabled=true",

    "dbms.default_listen_address=0.0.0.0",
    "dbms.memory.heap.initial_size=512m",
    "dbms.memory.heap.max_size=512m",
    "dbms.memory.pagecache.size=512m",
    "dbms.memory.transaction.global_max_size=2000m",
    "dbms.tx_log.rotation.retention_policy=1G size",
    "dbms.db.timezone=SYSTEM",
    "browser.remote_content_hostname_whitelist=*",
    "dbms.track_query_allocation=true",

    "dbms.logs.default_format=JSON",
    "dbms.logs.query.enabled=OFF",
    "dbms.logs.query.threshold=0",
    "dbms.logs.query.rotation.size=10M",
    "dbms.logs.query.rotation.keep_number=4",
    "dbms.logs.query.parameter_logging_enabled=true",
    "dbms.logs.query.time_logging_enabled=true",
    "dbms.logs.query.allocation_logging_enabled=true",
    "dbms.logs.query.page_logging_enabled=true",

    "dbms.connector.bolt.listen_address=:$nomNeo4jBoltPort",
    "dbms.connector.bolt.advertised_address=:$nomNeo4jBoltPort",
    "dbms.connector.http.listen_address=:$nomNeo4jHttpPort",
    "dbms.connector.http.advertised_address=:$nomNeo4jHttpPort",
    "dbms.backup.listen_address=0.0.0.0:$nomNeo4jBackupPort"
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
Invoke-Neo4jAdmin set-initial-password $Password
Write-Host "Done!" -ForegroundColor Green

# All done
Write-Host "`nSettings Complete" -ForegroundColor Green
