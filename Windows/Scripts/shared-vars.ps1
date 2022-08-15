$nomNeo4jBoltPort = "7688"
$nomNeo4jHttpPort = "7475"
$nomNeo4jBackupPort = "6363"

$jreZip = "zulu$($zuluVersion)-ca-jre$($jreVersion)-win_x64.zip"
$nomJreZip = "zulu$($nomZuluVersion)-ca-jre$($nomJreVersion)-win_x64.zip"
$neo4jZip = "neo4j-enterprise-$($neo4jVersion)-windows.zip"
$nomZip = "neo4j-ops-manager-server-$($nomVersion)-windows.zip"
$openSslZip = "OpenSSL-$($openSslVersion)_win32.zip"
$nomAgentZip = "agents/windows-amd64.zip"

$nomAgentBinLocation = Join-Path (Get-Location).Path "neo4j-ops-manager-agent-$($nomVersion)\bin\agent.exe"

$sslPfxLocation = Join-Path (Get-Location).Path "keystore.pfx"
$sslCrtLocation = Join-Path (Get-Location).Path "server.crt"

$logPath = Join-Path (Get-Location).Path "Logs"