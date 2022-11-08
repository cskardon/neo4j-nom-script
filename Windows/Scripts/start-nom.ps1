param($Password="", $SslPassword = "")

# Opening statement
Write-Host -ForegroundColor Green -BackgroundColor Black "Starting Neo4j Ops Manager!"

# Version
. .\scripts\version.ps1
. .\scripts\shared-vars.ps1
. .\scripts\functions.ps1

Write-Host "Setting Java Environment for this session ... " -NoNewline
. .\scripts\environment-java-17.ps1
Write-Host " Done!" -ForegroundColor Green

if(!(Test-Parameters(@{ Password = $Password; SslPassword = $SslPassword}))){
    break
}

$nomLocation = Join-Path (Get-Location).Path "neo4j-ops-manager-server-$($nomVersion)\lib\"

java -jar $nomLocation\server.jar `
        --spring.neo4j.uri=neo4j://localhost:$nomNeo4jBoltPort `
        --spring.neo4j.authentication.username=neo4j `
        --spring.neo4j.authentication.password=$Password `
        --server.port=8080 `
        --server.ssl.key-store-type=PKCS12 `
        --server.ssl.key-store=file:$sslPfxLocation `
        --server.ssl.key-store-password=$SslPassword `
        --grpc.server.port=9090 `
        --grpc.server.security.key-store-type=PKCS12 `
        --grpc.server.security.key-store=file:$sslPfxLocation `
        --grpc.server.security.key-store-password=$SslPassword `
        --jwt.secret=this-is-a-random-string-in-the-sense-this-isnt-production-setting-you-should-use-something-else