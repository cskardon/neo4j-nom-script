param($Stage="", $Password="", $SslPassword = "ssl-certificate-for-nom", $Start="false")
$Stage = $Stage.ToLower()

Write-Host "        _   __           __ __  _ " -ForegroundColor Cyan
Write-Host "       / | / /__  ____  / // / (_)" -ForegroundColor Yellow
Write-Host "      /  |/ / _ \/ __ \/ // /_/ / " -ForegroundColor Magenta
Write-Host "     / /|  /  __/ /_/ /__  __/ /  " -ForegroundColor Magenta
Write-Host "    /_/ |_/\___/\____/  /_/_/ /   " -ForegroundColor Yellow
Write-Host "                         /___/    " -ForegroundColor Cyan
Write-Host "                              "
Write-Host " ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄ " -ForegroundColor Cyan
Write-Host "▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌" -ForegroundColor Cyan
Write-Host "▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌" -ForegroundColor Magenta
Write-Host "▐░▌▐░▌    ▐░▌▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌" -ForegroundColor Magenta
Write-Host "▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌▐░▌ ▐░▐░▌ ▐░▌" -ForegroundColor White
Write-Host "▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌" -ForegroundColor White
Write-Host "▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌▐░▌   ▀   ▐░▌" -ForegroundColor White
Write-Host "▐░▌    ▐░▌▐░▌▐░▌       ▐░▌▐░▌       ▐░▌" -ForegroundColor Magenta
Write-Host "▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌" -ForegroundColor Magenta
Write-Host "▐░▌      ▐░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌" -ForegroundColor Cyan
Write-Host " ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀ " -ForegroundColor Cyan
Write-Host "                              "
Write-Host "       Neo4j Operations Manager        " -ForegroundColor DarkRed -BackgroundColor Yellow -NoNewline; 
Write-Host "`n";


if($Stage -eq "" -or $Stage -eq "scripts"){
    mkdir scripts -Force > $null
    Write-Host "Downloading Scripts ... "     
    $rootUri = "https://raw.githubusercontent.com/cskardon/neo4j-nom-script/main/Windows/Scripts/"

#     #Scripts we want in the 'scripts' folder
    $scriptNames = (
        "agent-settings.ps1",
        "download.ps1",
        "environment-java-17.ps1",
        "functions.ps1",
        "settings.ps1",
        "shared-vars.ps1",
        "ssl.ps1",
        "start-agent.ps1",
        "start-neo4j.ps1",
        "start-nom.ps1",
        "start.ps1",
        "tandcs.ps1",
        "unpack.ps1",
        "v3.ext",
        "version.ps1"
        );
  
    foreach($script in $scriptNames) {
        Write-Host "`t$script ... " -NoNewline
        try{        
            Invoke-WebRequest -Uri $rootUri$script -OutFile ./scripts/$script
            Write-Host "Done!" -ForegroundColor Green
        }
        catch{
            Write-Host "Failed!" -ForegroundColor Red
        }
    }
    
    Write-Host "`nScripts download complete!" -ForegroundColor Green
}

./scripts/tandcs.ps1
. ./scripts/functions.ps1

if(!(Test-Parameters(@{ Password = $Password; SslPassword = $SslPassword}))){
    break
}

Write-Host "Setting Execution Policy ... " -NoNewline
Set-ExecutionPolicy Bypass -Scope CurrentUser
Write-Host "Done!" -ForegroundColor Green

if($Stage -eq "" -or $Stage -eq "download"){
    ./scripts/download.ps1
    Write-Host "`n`nIf you saw any error messages above press " -NoNewLine; Write-Host "CTRL+C" -ForegroundColor Green -NoNewLine; Write-Host " and try to redownload, then run: '.\Setup-Windows-Single.ps1 -Stage unpack' to continue."
    Write-Host "To redownload any of the files specifically, run:"
    Write-Host "`t.\scripts\download.ps1 <name>" -ForegroundColor Yellow -NoNewline; Write-Host " where " -NoNewline; Write-Host "<name>" -ForegroundColor Yellow -NoNewline; Write-Host " can be one of: " -NoNewline; Write-Host "neo4j,jre,nom,jrenom,openssl" -ForegroundColor Yellow
    Write-Host "`nOtherwise - Press " -NoNewLine; Write-Host "ENTER" -NoNewLine -ForegroundColor Green; Write-Host " to continue.";
    $_ = Read-Host
}

if($Stage -eq "" -or $Stage -eq "unpack"){
    ./scripts/unpack.ps1
    $Stage = ""
}

if($Stage -eq "" -or $Stage -eq "ssl"){
    ./scripts/ssl.ps1 -Password $Password -SslPassword $SslPassword
    $stage = ""
}

if($Stage -eq "" -or $Stage -eq "settings"){
    ./scripts/settings.ps1 -Password $Password
    $Stage = ""
}

if($Start -eq "true"){
    ./scripts/start.ps1 -Password $Password -SslPassword $SslPassword
}