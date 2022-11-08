$nomNeo4jBoltPort = "7689"
$nomNeo4jHttpPort = "7475"
$nomNeo4jBackupPort = "6363"
$nomNeo4jServerDiscoveryPort = "5100"

$jreZip = "OpenJDK$($javaVersion)U-jre_x64_windows_hotspot_$($temurinFileVersion).zip"
$neo4jZip = "neo4j-enterprise-$($neo4jVersion)-windows.zip"
$nomZip = "neo4j-ops-manager-server-$($nomVersion)-windows.zip"
$openSslZip = "OpenSSL-$($openSslVersion)_win32.zip"
$nomAgentZip = "agents/windows-amd64.zip"

$neo4jLocation = Join-Path (Get-Location).Path "neo4j-enterprise-$($neo4jVersion)"
$javaJRELocation = Join-Path (Get-Location).Path "jdk-$($temurinHomeVersion)-jre"

$nomAgentBinLocation = Join-Path (Get-Location).Path "neo4j-ops-manager-agent-$($nomVersion)\bin\agent.exe"

$sslPfxLocation = Join-Path (Get-Location).Path "keystore.pfx"
$sslCrtLocation = Join-Path (Get-Location).Path "server.crt"

$logPath = Join-Path (Get-Location).Path "Logs"