#!/usr/bin/env bash

LINUX_KERNEL_TAR="linux-4.4.179.tar.xz"
ENABLE_CHECK_SUM="false"
if [ ! -f ${LINUX_KERNEL_TAR} ];then
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/${LINUX_KERNEL_TAR}
else
    if [ ${ENABLE_CHECK_SUM} == "true" ];then
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
if [ ${FORCE_EXTRACT_TAR} == "true" ];then
    rm -rf ${LINUX_KERNEL_TAR%.tar.xz}
fi
if [ ! -d ${LINUX_KERNEL_TAR%.tar.xz} ];then
    tar xvf ${LINUX_KERNEL_TAR}
fi
