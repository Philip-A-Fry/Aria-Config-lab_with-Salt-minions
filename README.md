# Aria Config Docker Lab
Inspired by (ok stolen from) seandjones92's project: https://github.com/seandjones92/Aria-Config-Docker-Lab/tree/main
- Added code to also deploy 5x Salt Minions (Ubuntu 22 containers)

Project to help run [Aria Automation Config](https://www.vmware.com/products/aria-automation/saltstack-config.html) in docker for testing and reference purposes. This assumes you have already paid for, or are otherwise entitled, to the installables for this product at [VMware Customer Connect](https://customerconnect.vmware.com/home). Environments created and managed by this project are not fit for production usage or anything resembling production usage, this is simply for self reference labs.

## Setup
To get started download the `*.tar` installable for el9 and place it in root of the project. Then run the `prep.sh` script. This will unpack the installer tar into the proper locations and will build an `.env` file for docker.
Once that is completed run `docker compose up -d`. After the containers are started it will take about 2 minutes for first time bootstrapping to complete.

Once everything is up you can load the web UI at [http://localhost:8080](http://localhost:8080)

## Troubleshooting
If the Salt Master container fails to stay up, run everything in the foreground: `docker compose up`
...then go accept the Master key in the RaaS web-UI. In my experience the Salt Master container will stay up once the master key has been accepted. 

## Factory reset
To reset your lab to a "like new" state run `./reset.sh`. and/or run `docker compose down`
