# Ubuntu docker image for Xilinx Petalinux tools 17.04

FROM  ubuntu:16.04
LABEL maintainer="lxzheng@xmu.edu.cn"

ARG install_dir=/opt
ARG installer_url=172.17.0.1:8000
ARG petalinux_dir=petalinux-v2017.4-final

ENV PETALINUX_VER=2017.4 				\
    PETALINUX=${install_dir}/${petalinux_dir}		\
    LANG=en_US.UTF-8 					\
    LANGUAGE="en_US:en"					\
    LC_ALL=en_US.UTF-8	

ENV PATH="${PETALINUX}/tools/linux-i386/arm-xilinx-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/arm-xilinx-linux-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/microblaze-xilinx-elf/bin:\
${PETALINUX}/tools/linux-i386/microblazeel-xilinx-linux-gnu/bin:\
${PETALINUX}/tools/linux-i386/petalinux/bin:\
${PETALINUX}/tools/common/petalinux/bin:\
${PATH}"

RUN dpkg --add-architecture i386 		&& \
    apt-get update 				&& \
    apt-get upgrade -y 				&& \
    apt-get install -y --no-install-recommends 	   \
# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, v2017.4
    tofrodos            \
    iproute             \
    gawk                \
    gcc                 \
    git-core            \
    make                \
    net-tools           \
    rsync               \
    wget                \
    tftpd-hpa           \
    zlib1g-dev          \
    flex                \
    bison               \
    bc                  \
    lib32z1             \
    lib32gcc1           \
    libncurses5-dev     \
    libncursesw5-dev    \
    libncursesw5:i386   \
    libncurses5:i386    \
    libbz2-1.0:i386     \
    libstdc++6:i386     \
    libselinux1         \
    libselinux1:i386    \
    diffstat		\
    xvfb		\
    chrpath		\
    socat		\
    unzip		\
    texinfo		\
    gcc-multilib	\
    build-essential	\
    libsdl1.2-dev	\
    libglib2.0-dev	\
    zlib1g:i386		\
    libssl-dev		\
    xterm		\
    autoconf		\
    libtool		\
    python3		\
    openssl		\
    lsb-release		\
    locales             \
    tftpd-hpa		\
    tftp-hpa		\
    cpio		\
# Using expect to install Petalinux automatically.
    expect              \
&& locale-gen en_US.UTF-8		\
&& mkdir /tftproot			\
&& rm -rf /var/lib/apt/lists/* /tmp/* 
COPY ./default/* /etc/default/

# Install Petalinux tools

WORKDIR $install_dir
COPY ./auto-install.sh $install_dir
RUN mkdir -p $install_dir/$petalinux_dir	&& \
    chmod 777 -R $install_dir			&& \
    ln -fs /bin/bash /bin/sh    		&& \
    useradd -ms /bin/bash petalinux
USER petalinux
WORKDIR $install_dir
RUN wget -q $installer_url/petalinux-v2017.4-final-installer.run && \
    chmod a+x petalinux-v2017.4-final-installer.run              && \
    ./auto-install.sh $install_dir/$petalinux_dir                && \
    rm -rf petalinux-v2017.4-final-installer.run


# ==================================================================================


