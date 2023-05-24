FROM centos:7 AS builder
ARG OPENPYPE_PYTHON_VERSION=3.9.16

ENV OPENPYPE_MONGO="mongodb://localhost:27017"

# update base
RUN yum -y install deltarpm \
    && yum -y update \
    && yum clean all

# add tools we need
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum -y install centos-release-scl git make devtoolset-7 cmake curl gcc \
        lib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel \
        openssl-devel openssl-libs tk-devel libffi-devel patchelf automake \
        autoconf patch ncurses ncurses-devel qt5-qtbase-devel xcb-util-wm \
        xcb-util-renderutil

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
RUN cd /opt/ && git clone https://github.com/ynput/OpenPype.git
RUN  chmod +x /opt/OpenPype/tools/build.sh

WORKDIR /opt/OpenPype
RUN pyenv local ${OPENPYPE_PYTHON_VERSION}

# create virtualenv
RUN chmod +x tools/create_env.sh && ./tools/create_env.sh

# get thirdparty libs
RUN chmod +x tools/fetch_thirdparty_libs.sh && ./tools/fetch_thirdparty_libs.sh

ENTRYPOINT [".poetry/bin/poetry", "run", "python", "start.py", "module"]
CMD ["--help"]
