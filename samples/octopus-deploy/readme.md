# Octopus deploy stack

This stack creates an octopus deploy setup that includes:
* the Octopus deploy server
* a listening tentacle
* a database to persist state of Octopus deploy server

## Deploy locally

* At a powershell prompt: `up.ps1` 
* Alternatively, double-click `up.bat`
* Wait for services to start
* Browse to the Octopus deploy UI: http://localhost:81

The above will start a new set of containers with a brand new installation of Octopus deploy

### First time setup

The following steps need to be performed once after starting the stack for the first time

**1. Create initial deployment environment**

The first time the stack is started above, the tentacle will fail to start. This is because the tentacle expects there to be a deployment environment named Development to be present in Octopus deploy.

To resolve:
1. Browse to the Octopus deploy UI: http://localhost:81
2. Create a new deployment environment named: Development
3. Restart the tentacle: `up.ps1`

**2. Persist master key**

Octopus deploy server needs a masterkey. When starting a brand new stack with a new set of volumes, the master key is persisted to the volume `octopus-deploy_server-masterkey`. The `docker-compose.yml` needs to be updated with this master key.

1. Browse on the file system to 'C:\ProgramData\docker\volumes\octopus-deploy_server-masterkey\_data'
2. Copy the contents of the file OctopusServer into the clipboard
3. Open the `docker-compose.yml`, find the `MasterKey` environment variable:
    * paste the value in the clipboard to replace the existing value
    * uncomment the `MasterKey` environment variable

## Deploy to swarm

* At a powershell prompt: `up.ps1 -SwarmDeploy` 
* Wait for octopus-deploy_server service to start (use `docker service ps octopus-deploy_server`)
* Browse to the Octopus deploy UI: http://localhost:81

The above will start a new set of containers with a brand new installation of Octopus deploy

### First time setup

The following steps need to be performed once after starting the stack for the first time

**1. Create initial deployment environment**

The first time the stack is started above, the tentacle will fail to start. This is because the tentacle expects there to be a deployment environment named Development to be present in Octopus deploy.

However, unlike deploying as a standalone stack outside of swarm, the tentacle service will continue to retry indefinitely.

To resolve:
1. Browse to the Octopus deploy UI: http://localhost:81
2. Create a new deployment environment named: Development
3. Wait for the octopus-deploy_tentacle service to start (use `docker service ps octopus-deploy_tentacle`)

**2. Persist master key**

See instructions for deploying locally. When instructed to replace the `MasterKey` environment variable, you will need to be modifying the `docker-compose-swarm.yml` file rather than `docker-compose.yml`

**3. Persist the Octopus deploy database**

Octopus will have created it's database when the stack starts. To ensure this database is reused, it needs to be reattached whenever a new database container is scheduled.

1. Open the `docker-compose-swarm.yml`, uncomment the line starting `# attach_dbs: "[{ 'dbName': ...`
