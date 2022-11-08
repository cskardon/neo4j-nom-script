# neo4j-nom-script
Scripts to install Neo4j NOM on a local machine for testing purposes.

Windows only at the moment.

## What will it do?

This will download a copy of 
* Neo4j Enterprise
* Neo4j Ops Manager (NOM)
* Java 17 SDK
* OpenSSL (on Windows)
* Scripts (from this repository)

It will extract them and setup a Neo4j instance and NOM server.

## How?

1. Download the `Setup-Nom-Server` file:

* [Windows (PS1)](https://raw.githubusercontent.com/cskardon/neo4j-nom-script/main/Windows/Scripts/Setup-Nom-Server.ps1)

2. Save to a `Scripts` folder
    ```
    mkdir Scripts
    cp .\Setup-Nom-Server.ps1 .\Scripts
    ```

3. Execute from _outside_ the `Scripts` folder
    ```
    .\Scripts\Setup-Nom-Server -Password <Neo4jAdminPassword> -SslPassword <Self-Signed SSL Certificate Password>
    ```

## Parameters?

Parameters are passed in via the standard PowerShell syntax, i.e. hyphen then name e.g. `-Password` or `-SslPassword`

### Required

* **Password**
  - Sets the default _neo4j_ user password on the Neo4j Server the NOM will connect to.

### Optional

* **SslPassword**
  - Set's the password for the self signed certificate that is generated for the NOM server to use
  - Default value: `"ssl-certificate-for-nom"`

* **Stage**
  - Use this to skip over parts of the process, for example, if you had downloaded and unpacked all the files but accidentally `CTRL+C`'d the script before generating the SSL certificates, you could run `.\Scripts\Setup-Nom-Server.ps1 -Password X -SslPassword Y -Stage ssl`
  - Valid values are:
    - scripts
    - download
    - unpack
    - ssl
    - settings
  - Default value: `""`

* **Start**
  - If this is set to `true` at the end of setting up everything the Neo4j Server and NOM will be started.
  - Default value: `false`

# Things to Note

As this is for local test versions, the assumption is that you would possibly be running another Neo4j instance locally as well, so the default ports for the NOM Neo4j Server are:

* Bolt: `7689`
* HTTP: `7475`
* Discovery: `5100`

# All installed? Now what?!

Assuming you have the Neo4j Server and NOM running you need Agents to actually perform the monitoring.

1. Goto NOM [https://localhost:8080](https://localhost:8080)
  - You will likely have to go 'unsafe' as we're using self signed SSL certificates
2. Sign in
  - Username: `admin`
  - Password: `passw0rd`
3. Accept license agreement
4. 'Get Started' (or go to: [https://localhost:8080/global-settings](https://localhost:8080/global-settings))
5. Register a new agent
6. Name/Description don't really matter, just be descriptive!
7. **Copy** your details - you'll need them later!
8. Close that window

## Agent!

Next we need to run the agent.
The actual file for this is in the `neo4j-ops-manager-agent-{VERSION}` folder - and it should be compatible with the current NOM version.

1. Edit the `./Scripts/agent-settings.ps1` file, and paste in the details you copied into the correct places:

```
$env:CONFIG_SERVER_ADDRESS = "localhost:9090"
$env:CONFIG_TOKEN_URL = "https://localhost:8080/api/login/agent"
$env:CONFIG_TOKEN_CLIENT_ID = "YOUR CLIENT ID HERE"
$env:CONFIG_TOKEN_CLIENT_SECRET = "YOUR CLIENT SECRET HERE"
```

**Ensure** you leave the quote (`"`) marks around the values, as they need to be there. Typically you _won't_ need to change the `CONFIG_SERVER_ADDRESS` or `CONFIG_TOKEN_URL` to use NOM.

2. Once the file has been setup, open a new CLI (Terminal or Powershell) and run:

`./Scripts/start-agent.ps1 -Password <YOUR MONITORED NEO4J PASSWORD>` 

This is the password you login to on your server being monitored. 

**NB.** if the user is different to the default `neo4j` user - you will need to change that in the `./Scripts/start-agent.ps1` file.

## Congratulations!

Hopefully you've now got a NOM server, NOM Neo4j Instance and NOM Agent all running, if you go to your server at: [https://localhost:8080/](https://localhost:8080) you should be able to see your instance all ready!
