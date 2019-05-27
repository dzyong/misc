#!/usr/bin/env bash

DEBUG="true"
LINUX_KERNEL_TAR="linux-4.4.179.tar.xz"
FORCE_CHECK_SUM="false"
if [ ! -f ${LINUX_KERNEL_TAR} ];then
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/${LINUX_KERNEL_TAR}
else
    if [ ${FORCE_CHECK_SUM} == "true" ];then
        KERNEL_SUMS="sha256sums.asc"
        rm -rf ${KERNEL_SUMS}
        wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/${KERNEL_SUMS}
        CHECK_SUM=`grep ${LINUX_KERNEL_TAR} ${KERNEL_SUMS}`
        if [ "`sha256sum ${LINUX_KERNEL_TAR}`" != "${CHECK_SUM}" ];then
            wget -c https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/${LINUX_KERNEL_TAR}
        fi
    fi
fi
FORCE_EXTRACT_TAR="false"
LINUX_KERNEL_DIR=${LINUX_KERNEL_TAR%.tar.xz}
if [ ${FORCE_EXTRACT_TAR} == "true" ];then
    rm -rf ${LINUX_KERNEL_DIR}
fi
if [ ! -d ${LINUX_KERNEL_DIR} ];then
    tar xvf ${LINUX_KERNEL_TAR}
fi
ARCH="arm64"
if [ ${ARCH} == "arm64" ];then
    CROSS_COMPILE="aarch64-linux-gnu-"
fi
cd ${LINUX_KERNEL_DIR}
FORCE_REBUILD="false"
if [ ${FORCE_REBUILD} == "true" ];then
    make distclean
fi
if [ ${DEBUG} == "true" ];then
    echo "Compile "${ARCH}" kernel with "${CROSS_COMPILE}"gcc"
fi
make ARCH=${ARCH} defconfig
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
