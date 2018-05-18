# Download base image ubuntu
FROM ubuntu:17.10

# Update software repo
RUN apt-get update

# Install required software
RUN apt-get -y install \
    gcc  \
    g++ \
    gdb \
    wget \
    curl \
    gfortran \
    make \
    patch \
    openmpi-bin \
    libopenmpi-dev \
    libdata-dumper-simple-perl \
    python \
    python3 \
    flex \
    bison \
    subversion \
    git \
    libunwind-dev \
    texinfo

# Install Score-P Developer tools
RUN cd /tmp/ && \
    curl -O -J  https://cloudstore.zih.tu-dresden.de/index.php/s/13c9S4j6KqC5t32/download\?path\=%2F\&files\=scorep-dev-06.tar.gz && \
    tar xvfz scorep-dev-06.tar.gz && \
    cd scorep-dev-06 && \
    ./install-scorep-dev.06.sh --prefix=/opt/scorep-dev-06

# Install OTF2
RUN cd /tmp && \
    wget http://www.vi-hps.org/upload/packages/otf2/otf2-2.1.1.tar.gz && \
    tar xvfz otf2-2.1.1.tar.gz && cd otf2-2.1.1 && \
    ./configure --prefix=/opt/otf2 --enable-static --enable-shared && make -j4 && make install

# Install Cube
RUN cd /tmp && \
    wget http://apps.fz-juelich.de/scalasca/releases/cube/4.4/dist/cubew-4.4.tar.gz && \
    wget http://apps.fz-juelich.de/scalasca/releases/cube/4.4/dist/cubelib-4.4.tar.gz && \
    tar xvfz cubew-4.4.tar.gz && \
    tar xvfz cubelib-4.4.tar.gz && \
    /tmp/cubew-4.4/configure --prefix=/opt/cubew --enable-static --enable-shared && make -j4 && make install && \
    /tmp/cubelib-4.4/configure --prefix=/opt/cubelib --enable-static --enable-shared && make -j4 && make install

# Install Opari2
RUN cd /tmp && \
    wget http://www.vi-hps.org/upload/packages/opari2/opari2-2.0.3.tar.gz && \
    tar xvfz opari2-2.0.3.tar.gz && \
    cd /tmp/opari2-2.0.3 && \
    ./configure --prefix=/opt/opari2 --enable-static --enable-shared && make -j4 && make install

# Install libunwind from our repo
RUN git clone https://github.com/score-p/libunwind /tmp/libunwind && \
    cd /tmp/libunwind && \
    ./autogen.sh && \
    ./configure --enable-static --enable-shared && make -j4 && make install
    
# Setting env
ENV SCOREP_DEV_ROOT /opt/scorep-dev-06
ENV PATH ${SCOREP_DEV_ROOT}/bin:${PATH}
ENV MANPATH ${SCOREP_DEV_ROOT}/share/man:${MANPATH}
ENV LD_LIBRARY_PATH ${SCOREP_DEV_ROOT}/lib:${LD_LIBRARY_PATH}
ENV OTF2_ROOT /opt/otf2
ENV PATH ${OTF2_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH ${OTF2_ROOT}/lib:${LD_LIBRARY_PATH}

ENV CUBEW_ROOT /opt/cubew
ENV CUBELIB_ROOT /opt/cubelib

ENV PATH ${CUBEW_ROOT}/bin:${PATH}
ENV PATH ${CUBELIB_ROOT}/bin:${PATH}
ENV LD_LIBRARY_PATH ${CUBEW_ROOT}/lib:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH ${CUBELIB_ROOT}/lib:${LD_LIBRARY_PATH}
ENV OPARI2_ROOT /opt/opari2
ENV PATH ${OPARI2_ROOT}/bin:${PATH}

ENV SCOREP_SRC_DIR /opt/scorep

WORKDIR ${SCOREP_SRC_DIR}

# Setting volumes
VOLUME [${SCOREP_SRC_DIR}]
