# openpype-module-docker

OpenPype-docker is designed to facilitate the use of modules within a Docker environment.


## Requirements

Docker with Compose plugin. To install the latest version of Docker, you can use the following script: [https://get.docker.com](https://get.docker.com)

## Installation

### Manual

```
git clone https://github.com/quadproduction/openpype-module-docker.git
cd openpype-module-docker
docker build -t openpype-module-docker:latest .
```
### From release

First, you need to [authenticating with a Personal Access Token (PAT)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic).

After to be logged in, pull the container image.

```
docker pull ghcr.io/quadproduction/openpype-module-docker:latest
docker tags ghcr.io/quadproduction/openpype-module-docker:latest openpype-module-docker:latest
```


## Run Module with Docker

Replace the desired arguments and environment variable in the following command:

```docker run -e OPENPYPE_MONGO=mongodb://localhost:27017 openpype-module-docker:latest args```

For example, to synchronize with Kitsu:

```docker run -e OPENPYPE_MONGO=mongodb://localhost:27017 openpype-module-docker:latest kitsu sync-service -l me@domain.ext -p my_password```

## For developers

Create a ticket and a merge request in case of any issues with this code.
To create a new build of the image, you need to tag the main branch once the MR is accepted.
