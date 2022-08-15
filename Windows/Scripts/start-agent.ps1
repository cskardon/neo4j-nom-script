param($Password="")

. .\scripts\version.ps1
. .\scripts\shared-vars.ps1
. .\scripts\agent-settings.ps1 $Password

$relativeLog = ".\Logs\Agent\log.log"
$agentLogPath = Join-Path $logPath "Agent"
if(!(Test-Path $agentLogPath)){
    New-Item -ItemType Directory -Force $agentLogPath
}

#Has to be relative
$env:CONFIG_TLS_TRUSTED_CERTS = $sslCrtLocation

#Log file info
$env:CONFIG_LOG_FILE = $relativeLog
$env:CONFIG_LOG_LEVEL = "info"



& $nomAgentBinLocation console