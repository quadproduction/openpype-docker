# openpype-docker
# OpenPype-docker

OpenPype-docker is designed to facilitate the use of modules within a Docker environment.


## Requirements

Docker with Compose plugin. To install the latest version of Docker, you can use the following script: [https://get.docker.com](https://get.docker.com)

## Installation

### Manual

```
git clone https://github.com/quadproduction/openpype-docker.git
docker build -t op-docker:latest .
```
### From release

``` docker pull ...TODO```

## Run

Replace the desired arguments and environment variable in the following command:

```docker run -e OPENPYPE_MONGO=mongodb://localhost:27017 op-docker:latest args```

For example, to synchronize with Kitsu:

```docker run -e OPENPYPE_MONGO=mongodb://localhost:27017 op-docker:latest kitsu sync-service -l me@domain.ext -p my_password```