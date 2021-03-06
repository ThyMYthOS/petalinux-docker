# Ubuntu docker image for Xilinx Petalinux & VIVADO tools 17.04 & pynq dev

FROM  ubuntu:16.04
LABEL maintainer="lxzheng@xmu.edu.cn"

ARG install_dir=/opt
ARG installer_url=172.17.0.1:8000
ARG petalinux_dir=petalinux-v2017.4-final
ARG vivado=Xilinx_Vivado_SDK_2017.4_1216_1

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
# Required tools and libraries of Petalinux,vivado,pynq.
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
    libxi6 		\
    libxtst6		\
    autoconf		\
    libtool		\
    python3		\
    openssl		\
    lsb-release		\
    locales             \
    tftpd-hpa		\
    tftp-hpa		\
    cpio		\
    automake		\
    binfmt-support	\
    device-tree-compiler\
    gperf		\
    help2man		\
    kpartx		\
    libbz2-1.0:i386	\
    lib32ncurses5	\
    lib32stdc++6	\
    libgnutls-dev	\
    libncurses5-dev	\
    libtool-bin		\
    libz-dev		\
    multistrap		\
    nfs-common		\
    dosfstools		\
    qemu-user-static	\
    texi2html		\
    u-boot-tools	\
    zerofree		\
    dosfstools		\
    sudo		\
# Using expect to install Petalinux automatically.
    expect              \
&& locale-gen en_US.UTF-8					\
&& mkdir /tftproot						\
&& ln -s /etc/init.d/tftpd-hpa /etc/rcS.d/S11tftpd-hpa		\
&& rm -rf /var/lib/apt/lists/* /tmp/*   			

COPY ./default/* /etc/default/

# Install Petalinux tools

WORKDIR $install_dir
COPY ./auto-install.sh $install_dir
RUN mkdir -p $install_dir/$petalinux_dir	&& \
    chmod 777 -R $install_dir			&& \
    ln -fs /bin/bash /bin/sh    		&& \
    mkdir /workspace				&& \
    chmod 777 /workspace			&& \
    useradd -ms /bin/bash xmu_wscec		&& \
    echo "xmu_wscec:xmu_wscec"|chpasswd		&& \
    adduser xmu_wscec sudo
USER xmu_wscec

# If you want a small image, you can run the following in a container with install_dir in a data volume.  The image can be gen use "docker commit"

WORKDIR $install_dir
RUN wget -q $installer_url/petalinux-v2017.4-final-installer.run && \
    chmod a+x petalinux-v2017.4-final-installer.run              && \
    ./auto-install.sh $install_dir/$petalinux_dir                && \
    rm -rf petalinux-v2017.4-final-installer.run		 && \
    wget $install_dir/$vivado.tar.gz -q 			 && \
    echo "Extracting Vivado tar file" 				 && \
    tar xzf $vivado.tar.gz 					 && \
    $vivado/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA     \
		   --batch Install --config install_config.txt 	 && \
    rm -rf $vivado						    


# ==================================================================================


