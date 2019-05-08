# devops
Configurations, tests, and build scripts to build the entire system into Docker images

## Build docker image
docker build -t second-state/devchain:latest .

## Create Devchain container

mkdir $(your_local_path)

docker run --rm -v $(your_local_path):/devchain second-state/



## Init local devchain node
devchain node init --home /devchain


## Update genesis parameters
npm install
node genesis_generator.js --from-genesis $(your_local_path)/config/genesis.json

## Start Devchain node with custom parameters
docker run --privileged --name devchain -v $(your_local_path):/devchain -t -p 26657:26657 -p 8545:8545 second-state/devchain node start --home /devchain


