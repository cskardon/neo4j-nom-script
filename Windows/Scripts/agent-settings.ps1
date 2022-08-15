param($Password)

. ./scripts/functions.ps1

if(!(Test-Parameters(@{ Password = $Password }))){
    break
}

#You need to set these up with the information copied from the Agent Registration on 
#the NOM Server.

#NB - the information might say 'nom:9090' instead of 'localhost:9090' - either will work, the SSL 
#     certificates are written to cope with both domains.

$env:CONFIG_SERVER_ADDRESS = "localhost:9090"
$env:CONFIG_TOKEN_URL = "https://localhost:8080/api/login/agent"
$env:CONFIG_TOKEN_CLIENT_ID = "YOUR CLIENT ID HERE"
$env:CONFIG_TOKEN_CLIENT_SECRET = "YOUR CLIENT SECRET HERE"


#This is the configuration for the server being monitored

# This is the name of the instance you will see in the NOM, name it something useful, for example, server name,
# server role, e.g. Movies Server, Demos Server etc
$env:CONFIG_INSTANCE_1_NAME = "Neo4j Local Server"

# The bolt address to your server, you should be running the agent on the server instance itself
# so this is likely to be 'localhost'. The Schema should be 'bolt' not 'neo4j' as we're specifically
# monitoring this server, and we don't want routing.
$env:CONFIG_INSTANCE_1_BOLT_URI = "bolt://localhost:7687"

# An administrator username, by default this is 'neo4j'
# The password is passed in as a parameter.
$env:CONFIG_INSTANCE_1_BOLT_USERNAME = "neo4j"
$env:CONFIG_INSTANCE_1_BOLT_PASSWORD = $Password