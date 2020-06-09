#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:19.10

RUN apt update && apt install -y --no-install-recommends \
    git \
    wget \
    make \
    patch \
    gfortran \
    curl \
    libdata-dumper-simple-perl \
    python \
    python3 \
    flex \
    bison \
    subversion \
    texinfo \
    build-essential \
    software-properties-common \
    libncurses5-dev \
    zlib1g-dev \
    locales \
    pkg-config \
    libndctl-dev \
    libdaxctl-dev \
    cmake \
    autotools-dev \
    doxygen \
    uncrustify \
    libtool \
    m4 \
    autoconf \
    dh-autoreconf \
    gcc \
    g++ \
    clang-9 \
    clang \
    clangd-9 \
    llvm-9 \
    llvm-9-dev \
    llvm-9-tools \
    libclang-9-dev \
    python-clang-9 \
    silversearcher-ag \
    rapidjson-dev \
    vim \
    autogen \
    gcc-9-plugin-dev \
    libmpich-dev \
    mpich

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install OTF2
RUN cd /tmp && \
    wget https://www.vi-hps.org/cms/upload/packages/otf2/otf2-2.2.tar.gz && \
    tar xfz otf2-2.2.tar.gz && cd otf2-2.2 && \
    ./configure --prefix=/opt/otf2 --enable-static --enable-shared && make -j4 && make install
ENV OTF2_DIR /opt/otf2

# Install Cube
RUN cd /tmp && \
    wget http://apps.fz-juelich.de/scalasca/releases/cube/4.5/dist/cubew-4.5.tar.gz && \
    wget http://apps.fz-juelich.de/scalasca/releases/cube/4.5/dist/cubelib-4.5.tar.gz && \
    tar xfz cubew-4.5.tar.gz && \
    tar xfz cubelib-4.5.tar.gz && \
    /tmp/cubew-4.5/configure --enable-static --enable-shared --prefix=/opt/cubew && make -j4 && make install && \
    /tmp/cubelib-4.5/configure --enable-static --enable-shared --prefix=/opt/cubelib && make -j4 && make install

ENV CUBEW_DIR /opt/cubew
ENV CUBELIB_DIR /opt/cubelib

# Install Opari2
RUN cd /tmp && \
    wget https://www.vi-hps.org/cms/upload/packages/opari2/opari2-2.0.4.tar.gz && \
    tar xfz opari2-2.0.4.tar.gz && \
    cd /tmp/opari2-2.0.4 && \
    ./configure --prefix=/opt/opari2 --enable-static --enable-shared && make -j4 && make install

ENV OPARI2_DIR /opt/opari2

# Install libunwind from our repo
RUN git clone https://github.com/score-p/libunwind /tmp/libunwind && \
    cd /tmp/libunwind && \
    ./autogen.sh && \
    ./configure --enable-static --enable-shared && make -j4 && make install

ENV LD_LIBRARY_PATH /usr/local/lib/:${LD_LIBRARY_PATH}

# Install dir of scorep build
ENV SCOREP_DIR /opt/scorep

ENV PATH ${OTF2_DIR}/bin:${PATH}

ENV LD_LIBRARY_PATH ${OPARI2_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${CUBEW_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${CUBELIB_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${OTF2_DIR}/lib:${LD_LIBRARY_PATH}

RUN mkdir /tests

RUN cd /tmp && \
    wget http://perftools.pages.jsc.fz-juelich.de/utils/afs-dev/afs-dev-latest.tar.gz && \
    tar xfz afs-dev-latest.tar.gz && \
    cd afs-dev-latest && \
    ./install-afs-dev.sh --prefix=/opt/afs-dev-latest --continue-after-download

ENV LD_LIBRARY_PATH /opt/afs-dev-latest/lib:${LD_LIBRARY_PATH}
ENV PATH /opt/afs-dev-latest/bin:${PATH}
ENV CPATH /opt/afs-dev-latest/include:${CPATH}
ENV C_INCLUDE_PATH /opt/afs-dev-latest/include:${C_INCLUDE_PATH}

RUN useradd --create-home --shell /bin/bash -u 1000 appuser
USER appuser

VOLUME [/tests]
