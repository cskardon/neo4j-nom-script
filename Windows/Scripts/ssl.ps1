param($Password="", $SslPassword="")


# Opening statement
Write-Host "Generating SSL Key"

# Version
. .\scripts\version.ps1
. .\scripts\functions.ps1

if(!(Test-Parameters(@{ Password = $Password; SslPassword = $SslPassword}))){
    break
}

# Directories
$openSslLocation = Join-Path (Get-Location).Path "openssl-$($openSslVersion)_win32"
$env:OPENSSL_CONF = "$($openSslLocation)\openssl.cnf"
$openSslExe = Join-Path $openSslLocation openssl.exe

Write-Host "server.key"
& $openSslExe genrsa -out server.key 2048
Write-Host "server.csr"
& $openSslExe req -new -key server.key -out server.csr -subj "/C=GB/ST=Launceston/L=./O=Anabranch/OU=./CN=server"
Write-Host "server.crt"
& $openSslExe x509 -req -in server.csr -signkey server.key -out server.crt -days 365 -sha256 -extfile .\scripts\v3.ext
Write-Host "keystore.pfx"
& $openSslExe pkcs12 -export -out keystore.pfx -inkey server.key -in server.crt -passout pass:$SslPassword
Write-Host "all done"
