# Encapsulate Xilinx Petalinux tools 2015.2.1 into docker image

FROM  ubuntu:14.04
LABEL maintainer="manuel.stahl@awesome-technologies.de"

ARG install_dir=/opt
ARG installer_url=172.17.0.1:8000

ENV PETALINUX_VER=2015.2.1
ENV PETALINUX=${install_dir}/petalinux-v$PETALINUX_VER-final
ENV PATH="${PETALINUX}/tools/linux-i386/arm-xilinx-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/arm-xilinx-linux-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/microblaze-xilinx-elf/bin:\
${PETALINUX}/tools/linux-i386/microblazeel-xilinx-linux-gnu/bin:\
${PETALINUX}/tools/linux-i386/petalinux/bin:\
${PETALINUX}/tools/common/petalinux/bin:\
${PATH}"

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, v2015.2.1.
    tofrodos            \
    iproute             \
    gawk                \
    gcc                 \
    git-core            \
    make                \
    net-tools           \
    ncurses-dev         \
    libncurses5-dev     \
    tftpd               \
    zlib1g-dev          \
    libssl-dev          \
    rsync               \
    wget                \
    flex                \
    bison               \
    bc                  \
    lib32z1             \
    lib32ncurses5       \
    lib32bz2-1.0        \
    lib32stdc++6        \
    libselinux1         \
# Using expect to install Petalinux automatically.
    expect              \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Install Petalinux tools
WORKDIR $install_dir
COPY ./auto-install.sh .
RUN chmod a+x auto-install.sh

# There are two methods to get petalinux installer in:
# 1. Using COPY instruction, but it will significantly increase the size of image.
#    In this way, you should place installer to context which is sent to docker daemon.
# 2. Getting installer via network, but it need a server exit. If there is not a web
#    address to host it, a simple http server can be set up locally using python.
# You should choose one of them.
# = 1. =============================================================================
# COPY ./petalinux-v$PETALINUX_VER-final-installer.run .
# RUN  ls / && chmod a+x petalinux-v$PETALINUX_VER-final-installer.run \
#      && ./auto-install.sh $install_dir \
#      && rm -rf petalinux-v$PETALINUX_VER-final-installer.run
# = 2. =============================================================================
RUN wget -q $installer_url/petalinux-v$PETALINUX_VER-final-installer.run && \
    chmod a+x petalinux-v$PETALINUX_VER-final-installer.run              && \
    ./auto-install.sh $install_dir                                       && \
    rm -rf petalinux-v$PETALINUX_VER-final-installer.run
# ==================================================================================

# RUN echo 'alias plbuild="petaliux-build"' >> ~/.bashrc      && \
#     echo 'alias plcreate="petaliux-create"' >> ~/.bashrc    && \
#     echo 'alias plconfig="petalinx-config"' >> ~/.bashrc    && \

RUN ln -fs /bin/bash /bin/sh    # bash is PetaLinux recommended shell
WORKDIR /workspace

RUN petalinux-util --webtalk off
