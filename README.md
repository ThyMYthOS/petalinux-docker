# Encapsulate Xilinx PetaLinux &Vivado tools 2017.4 into docker image

## Versions
- PetaLinux version: 2017.4
- Vivado version:2017.4
- Base image: Ubuntu:16.04
- based on the projects: https://github.com/xaljer/petalinux-docker
		         https://github.com/BBN-Q/vivado-docker

## Features
- Environment variables are set, so no need to source settings.sh on launch.
- The default working directory is `/workspace`, you can mount a volume to there to save your data.

## Build image
You can use `build-image.sh` to build the image, which set up a HTTP server using python on where PetaLinux & vivado tools installer is, and do `docker build` to build image. The first parameter of this script is the directory of PetaLinux & vivado installer. 

There are two `build-arg` in the Dockerfile, one is `installer_url`, which is set by `build-image.sh` using IP of docker network bridge, another is `install_dir`, which is `/opt` by default.

If you want a small image, petalinux & vivado can be installed in a container with install_dir in a data volume.  The image can be gen use "docker commit"

## More help


- More details for the Dockerfile and build process are recorded in [xaljer blog](blog.csdn.net/elegant__), which is written in Chinese.

## PetaLinux reference

[ug1144-petalinux-tools-reference-guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_4/ug1144-petalinux-tools-reference-guide.pdf)

