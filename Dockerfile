FROM debian:bullseye AS builder
USER root
ARG DEBIAN_FRONTEND=noninteractive
ARG OPENPYPE_PYTHON_VERSION=3.9.16
ARG OPENPYPE_QUAD_SYNCHRO_VERSION="3.16.9-quad-1.17.4"

LABEL org.opencontainers.image.name="openpype-module-docker"
LABEL org.opencontainers.image.documentation="https://github.com/quadproduction/openpype-module-docker"

ENV OPENPYPE_MONGO="mongodb://localhost:27017"

# Update base
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    ca-certificates bash git cmake make curl wget build-essential libssl-dev zlib1g-dev libbz2-dev  \
    libreadline-dev libsqlite3-dev llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev  \
    libffi-dev liblzma-dev patchelf libgl1 libxcb-* libxkbcommon* libdbus-1-3

# Clone OpenPype
RUN cd /opt/ && \
    git clone --recurse-submodules https://github.com/quadproduction/OpenPype.git && \
    cd OpenPype && \
    git fetch --all --tags

WORKDIR /opt/OpenPype

# Install pyenv
RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"'>> $HOME/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc

SHELL ["/bin/bash", "--login", "-c"]

RUN source ~/.bashrc

# Install python
RUN pyenv install ${OPENPYPE_PYTHON_VERSION}
RUN pyenv local ${OPENPYPE_PYTHON_VERSION}

# The OPENPYPE_QUAD_SYNCHRO_VERSION should be re-apply/updated when the docker container is (re)started
# First Add a container environnement variable named OPENPYPE_QUAD_SYNCHRO_VERSION set to the version wanted, then
# set the container CMD to:
# '/bin/bash' '-c' 'git stash && git checkout tags/${OPENPYPE_QUAD_SYNCHRO_VERSION} && YOUR_ORIGINAL_CMD_HERE'
RUN git checkout tags/${OPENPYPE_QUAD_SYNCHRO_VERSION}

RUN pyenv local ${OPENPYPE_PYTHON_VERSION}

# Create virtualenv
RUN ./tools/create_env.sh && ./tools/fetch_thirdparty_libs.sh

# Activate the virtualenv
RUN source .venv/bin/activate

ENTRYPOINT [""]
CMD [""]
