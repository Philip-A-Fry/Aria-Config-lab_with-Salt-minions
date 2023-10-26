# Aria Config Docker Lab
Inspired by (ok, stolen from) seandjones92's project: https://github.com/seandjones92/Aria-Config-Docker-Lab/tree/main
- Added code to also deploy 5x Salt Minions (Ubuntu 22 containers)

Project to help run [Aria Automation Config](https://www.vmware.com/products/aria-automation/saltstack-config.html) in docker for testing and reference purposes. This assumes you have already paid for, or are otherwise entitled, to the installables for this product at [VMware Customer Connect](https://customerconnect.vmware.com/home). Environments created and managed by this project are not fit for production usage or anything resembling production usage, this is simply for self reference labs.

## Setup
- To get started, download the `*.tar.gz` installer for EL9 from [VMware Customer Connect](https://customerconnect.vmware.com/home), then extract the `*.tar` file from it.  
- Place the `*.tar` file in the root of the project - the "Aria-Config-lab_with-5-Salt-minions" directory.
- Run the command (on Linux / macOS) to make the two bash scripts executable: `chmod +x reset.sh && chmod +x prep.sh`
- Then run the `prep.sh` script. This will unpack the installer tar into the proper locations and will build an `.env` file for docker.
- I've found it helpful to first run `docker compose build` but this may not be obligatory
- Once all that is completed, run `docker compose up -d`. Once the containers are started it will take about 2-3 minutes for first time bootstrapping to complete.

Once everything is up you can load the web UI at [http://localhost:8080](http://localhost:8080)

## Troubleshooting
!! Note - this has only been successfully tested on a Apple Silicon Mac (ARM CPU)!! It may or may not work on an Docker host with an Intel or AMD CPU. It may be possible to run the .sh script on Windows via WSL, but this has not been tested. 

If the Salt Master container fails to stay up, run everything in the foreground: `docker compose up`
...then go accept the Master key in the RaaS web-UI. In my experience the Salt Master container will stay up once the master key has been accepted. 

You MUST accept the Master key first before Minion keys will appear (and can be accepted). 

## Factory reset
To reset your lab to a "like new" state run `./reset.sh`. and/or run `docker compose down`
