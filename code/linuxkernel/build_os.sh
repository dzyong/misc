#!/usr/bin/env bash

DEBUG="true"
CURDIR=`pwd`
LINUX_KERNEL_TAR="linux-5.15.161.tar.xz"
LINUX_KERNEL_DIR=v$(sed -r 's/linux-([1-9]).*/\1/' <<< $LINUX_KERNEL_TAR).x
LINUX_KERNEL_URL=https://mirrors.ustc.edu.cn/kernel.org/linux/kernel/${LINUX_KERNEL_DIR}
FORCE_CHECK_SUM="false"
if [ ! -f ${LINUX_KERNEL_TAR} ];then
    wget -c ${LINUX_KERNEL_URL}/${LINUX_KERNEL_TAR}
else
    if [ ${FORCE_CHECK_SUM} == "true" ];then
        KERNEL_SUMS="sha256sums.asc"
        rm -rf ${KERNEL_SUMS}
        wget -c ${LINUX_KERNEL_URL}/${KERNEL_SUMS}
        CHECK_SUM=`grep ${LINUX_KERNEL_TAR} ${KERNEL_SUMS}`
        if [ "`sha256sum ${LINUX_KERNEL_TAR}`" != "${CHECK_SUM}" ];then
            wget -c ${LINUX_KERNEL_URL}/${LINUX_KERNEL_TAR}
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
ARCH=${ARCH-"arm64"}
if [ ${ARCH} == "arm64" ];then
    CROSS_COMPILE="aarch64-linux-gnu-"
else
    CROSS_COMPILE="arm-linux-gnueabi-"
fi
cd ${LINUX_KERNEL_DIR}
FORCE_REBUILD="false"
if [ ${FORCE_REBUILD} == "true" ];then
    make distclean
fi
if [ ${DEBUG} == "true" ];then
    echo "Compile "${ARCH}" kernel with "${CROSS_COMPILE}"gcc"
fi
if [ ! -f .config ];then
    make ARCH=${ARCH} defconfig
    echo "CONFIG_UEVENT_HELPER=y" >> .config
fi
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
INIT_RD=${CURDIR}"/cpio/"
rm -rf ${INIT_RD}
mkdir ${INIT_RD}
make ARCH=${ARCH} modules_install INSTALL_MOD_PATH=${INIT_RD}
OUT=${CURDIR}"/out"
rm -rf ${OUT}
mkdir ${OUT}
if [ ${ARCH} == "arm64" ];then
  cp arch/arm64/boot/Image.gz ${OUT}
else
  cp arch/arm/boot/zImage ${OUT}
fi
cd ${CURDIR}
BUSY_BOX_TAR=busybox-1.30.1.tar.bz2
if [ ! -f ${BUSY_BOX_TAR} ];then
  wget -c https://busybox.net/downloads/${BUSY_BOX_TAR}
else
    if [ ${FORCE_CHECK_SUM} == "true" ];then
        BUSYBOX_SUMS=${BUSY_BOX_TAR}".sha256"
        rm -rf ${BUSYBOX_SUMS}
        wget -c https://busybox.net/downloads/${BUSYBOX_SUMS}
        CHECK_SUM=`cat ${BUSYBOX_SUMS}`
        if [ "`sha256sum ${BUSY_BOX_TAR}`" != "${CHECK_SUM}" ];then
            wget -c https://busybox.net/downloads/${BUSY_BOX_TAR}
        fi
    fi
fi
BUSYBOX_DIR=${BUSY_BOX_TAR%.tar.bz2}
if [ ${FORCE_EXTRACT_TAR} == "true" ];then
    rm -rf ${BUSYBOX_DIR}
fi
if [ ! -d ${BUSYBOX_DIR} ];then
    tar xvf ${BUSY_BOX_TAR}
fi
cd ${BUSYBOX_DIR}
make ARCH=${ARCH} defconfig
echo "CONFIG_STATIC=y" >> .config
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} CONFIG_PREFIX=_install install
BUSYBOX_INSTALL_DIR=`pwd`"/_install"
cd ${INIT_RD}
cp -a ${BUSYBOX_INSTALL_DIR}/* ${INIT_RD}
cat > init << EOF
#!/bin/sh
mount -a
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
mount -t ext4 /dev/vda /disk
echo "switch to real root"
exec switch_root /disk /init
EOF
chmod +x init
rm -rf linuxrc
mkdir etc dev proc sys tmp disk
cat > etc/fstab << EOF
proc  /proc proc  defaults 0 0
sysfs /sys  sysfs defaults 0 0
tmpfs /tmp  tmpfs  defaults 0 0
tmpfs /dev  tmpfs  defaults 0 0
EOF
find . | cpio -o -Hnewc |gzip -9 > ${OUT}/image.cpio.gz
DISK_DIR=${CURDIR}"/disk/"
rm -rf ${DISK_DIR}
mkdir ${DISK_DIR}
cd ${DISK_DIR}
cp -a ${INIT_RD}/* ${DISK_DIR}
ln -sf sbin/init init
rm -rf disk
EXT_DIR=${CURDIR}/ext
if [ -d ${EXT_DIR} ];then
  cp -r ${CURDIR}/ext ./
fi
mkdir -p etc/init.d
cat > etc/init.d/rcS << EOF
mount -a
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
EOF
chmod +x etc/init.d/rcS
cat > etc/inittab << EOF
::sysinit:/etc/init.d/rcS
::askfirst:-/bin/sh
::restart:/sbin/init
::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r
::shutdown:/sbin/swapoff -a
EOF
dd if=/dev/zero of=${OUT}/disk.img bs=1M count=32
mkfs.ext4 ${OUT}/disk.img
rm -rf ${CURDIR}/mnt
mkdir ${CURDIR}/mnt
sudo mount ${OUT}/disk.img ${CURDIR}/mnt
sudo cp -a ${DISK_DIR}/* ${CURDIR}/mnt/
sudo umount ${CURDIR}/mnt
#qemu-system-aarch64 -cpu cortex-a53 -smp 2 -m 512M -kernel Image.gz -nographic -initrd image.cpio.gz -M virt
#qemu-system-aarch64 -cpu cortex-a53 -smp 2 -m 512M -kernel Image.gz -nographic -M virt -drive file=disk.img,format=raw -append "root=/dev/vda" -initrd image.cpio.gz
#qemu-system-arm -kernel zImage -nographic -initrd image.cpio.gz -M versatilepb -append "console=ttyAMA0,115200"
#qemu exit: ctrl-a x; console: ctral-a c; debug: -S -s/-g; gdb vmlinux(virt addr); add-symbol-file vmlinux -s .head.text 0x40080000(phy addr)
