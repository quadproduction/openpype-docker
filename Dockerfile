FROM debian:bullseye AS builder
ARG OPENPYPE_PYTHON_VERSION=3.9.16
ARG DEBIAN_FRONTEND=noninteractive
ARG OPENPYPE_QUAD_SYNCHRO_VERSION="3.16.9-quad-1.0.0"

LABEL org.opencontainers.image.name="openpype-module-docker"
LABEL org.opencontainers.image.documentation="https://github.com/quadproduction/openpype-module-docker"

ENV OPENPYPE_MONGO="mongodb://localhost:27017"


# update base
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates bash git cmake make curl wget build-essential libssl-dev \
    zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev patchelf libgl1

# install pyenv
RUN curl https://pyenv.run | bash && \
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"'>> $HOME/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> $HOME/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# install python
RUN pyenv install ${OPENPYPE_PYTHON_VERSION}

# clone openpype
RUN cd /opt/ && \
    git clone --recurse-submodules https://github.com/quadproduction/OpenPype.git && \
    cd OpenPype && \
    git fetch --all --tags

WORKDIR /opt/OpenPype

# The OPENPYPE_QUAD_SYNCHRO_VERSION should be re-apply/updated when the docker container is (re)started
# First Add a container environnement variable named OPENPYPE_QUAD_SYNCHRO_VERSION set to the version wanted, then
# set the container CMD to:
# '/bin/bash' '-c' 'git stash && git checkout tags/${OPENPYPE_QUAD_SYNCHRO_VERSION} && YOUR_ORIGINAL_CMD_HERE'
RUN git checkout tags/${OPENPYPE_QUAD_SYNCHRO_VERSION}

RUN pyenv local ${OPENPYPE_PYTHON_VERSION}

# create virtualenv
RUN ./tools/create_env.sh && ./tools/fetch_thirdparty_libs.sh

# Fix version compatibility with kitsu ^0.16.0
# TODO: Remove this when gazu is updated to 0.9.0 in poetry.lock
RUN sed -i "s/gazu = \"^0.8.34\"/gazu = \"^0.9.0\"/" pyproject.toml && \
    .poetry/bin/poetry update

ENTRYPOINT [""]
CMD [""]
