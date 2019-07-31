#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:19.04

RUN apt update && apt install -y --no-install-recommends \
    git \
    wget \
    make \
    patch \
    gfortran \
    curl \
    openmpi-bin \
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
    libopenmpi-dev \
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
    clang-8 \
    clang \
    llvm-8 \
    llvm-8-dev \
    llvm-8-tools \
    libclang-8-dev \
    python-clang-8 \
    silversearcher-ag \
    rapidjson-dev \
    vim \
    pmdk-tools \
    autogen \
    bear
    # Install CMake
    # Add llvm keys
    # Install llvm and gcc7

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install ccls
RUN git clone https://github.com/MaskRay/ccls --depth=1 \
    && cd ccls \
    && cmake . \
    && make -j4 \
    && make install

# Install OTF2
RUN cd /tmp && \
    wget https://www.vi-hps.org/cms/upload/packages/otf2/otf2-2.1.1.tar.gz && \
    tar xfz otf2-2.1.1.tar.gz && cd otf2-2.1.1 && \
    ./configure --prefix=/opt/otf2 --enable-static --enable-shared && make -j4 && make install
ENV OTF2_DIR /opt/otf2

# Install Cube
RUN cd /tmp && \
    wget http://apps.fz-juelich.de/scalasca/releases/cube/4.4/dist/cubew-4.4.2.tar.gz && \
    wget http://apps.fz-juelich.de/scalasca/releases/cube/4.4/dist/cubelib-4.4.3.tar.gz && \
    tar xfz cubew-4.4.2.tar.gz && \
    tar xfz cubelib-4.4.3.tar.gz && \
    /tmp/cubew-4.4.2/configure --enable-static --enable-shared --prefix=/opt/cubew && make -j4 && make install && \
    /tmp/cubelib-4.4.3/configure --enable-static --enable-shared --prefix=/opt/cubelib && make -j4 && make install

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

#Install PMDK 1.4.2
RUN cd /tmp && \
    wget https://github.com/pmem/pmdk/archive/1.4.2.tar.gz && \
    tar xfz 1.4.2.tar.gz && \
    cd pmdk-1.4.2 && \
    make install prefix=/opt/pmdk

ENV PMDK_DIR /opt/pmdk

# Install dir of scorep build
ENV SCOREP_DIR /opt/scorep

ENV PATH ${OTF2_DIR}/bin:${PATH}
ENV PATH ${PMDK_DIR}/bin:${PATH}
ENV PATH ${SCOREP_DIR}/bin:${PATH}

ENV LD_LIBRARY_PATH /usr/local/lib/:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${SCOREP_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${PMDK_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${OPARI2_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${CUBEW_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${CUBELIB_DIR}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${OTF2_DIR}/lib:${LD_LIBRARY_PATH}

# Score-P could be configured like
# ../configure --enable-shared --with-mpi=openmpi --disable-dependency-tracking \
#              --with-otf2=$OTF2_DIR \
#              --with-opari2=$OPARI2_DIR \
#              --with-cubelib=$CUBELIB_DIR \
#              --with-cubew=$CUBEW_DIR \
#              --with-pmdk=$PMDK_DIR \
#              --prefix=$SCOREP_DIR

RUN mkdir /tests

VOLUME [/tests]