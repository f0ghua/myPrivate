#!/bin/sh

PART=kernel

TOOLCHAIN_DIR=~/var-distcc/tools/realtek/bin
CROSS_COMPILER_PREFIX=/opt/toolchain_mips_nofpu/bin/mips-linux-
CROSS_COMPILER_PREFIX_1=/opt/toolchain_mips_nofpu/usr/bin/
BIN_CACHE_DIR=/opt/toolchain_mips_nofpu/bin-ccache
KERNEL_COMPILER_PREFIX=/RSDK_LINUX/rcc/bin/mips-linux-


mkdir -p ${TOOLCHAIN_DIR}
if [ "$PART" == "kernel" ];then
ln -sf ${KERNEL_COMPILER_PREFIX}gcc ${TOOLCHAIN_DIR}/gcc
ln -sf ${KERNEL_COMPILER_PREFIX}gcc ${TOOLCHAIN_DIR}/cc
ln -sf ${KERNEL_COMPILER_PREFIX}g++ ${TOOLCHAIN_DIR}/g++
ln -sf ${KERNEL_COMPILER_PREFIX}c++ ${TOOLCHAIN_DIR}/c++
else
ln -sf ${BIN_CACHE_DIR}/mips-linux-uclibc-gcc ${BIN_CACHE_DIR}/gcc
ln -sf ${BIN_CACHE_DIR}/mips-linux-uclibc-cc ${BIN_CACHE_DIR}/cc

ln -sf ${CROSS_COMPILER_PREFIX_1}ccache ${TOOLCHAIN_DIR}/gcc
ln -sf ${CROSS_COMPILER_PREFIX_1}ccache ${TOOLCHAIN_DIR}/cc
ln -sf ${CROSS_COMPILER_PREFIX}g++ ${TOOLCHAIN_DIR}/g++
ln -sf ${CROSS_COMPILER_PREFIX}c++ ${TOOLCHAIN_DIR}/c++
fi


if [[ `echo $PATH|grep ${TOOLCHAIN_DIR}` == "" ]];then
    PATH=${TOOLCHAIN_DIR}:${PATH};export PATH
else
    echo PATH has existed!
fi

# client
export DISTCC_HOSTS='localhost 172.21.5.110'
#make -j8 CC=distcc

# server
#distccd --daemon --allow 172.21.0.0/16
