# build.sh
#
# (c) Copyright 2013
# Allwinner Technology Co., Ltd. <www.allwinnertech.com>
# James Deng <csjamesdeng@allwinnertech.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# Notice:
#   1. Board option is useless.
#   2. We Only support to copy u-boot.bin to common directory right now.

#Check number of CPU Cores on host platform to set jobs count
if [[ $LICHEE_HOST_PLATFORM == 'darwin' ]]; then
  export CROSS_COMPILE=arm-linux-gnueabihf-
  cpu_cores='sysctl -a | grep machdep.cpu | grep core_count'
else
  export CROSS_COMPILE=arm-linux-gnueabi-
  cpu_cores=`cat /proc/cpuinfo | grep "processor" | wc -l`
  if [ ${cpu_cores} -le 8 ] ; then
      jobs=${cpu_cores}
    else
      jobs=`expr ${cpu_cores} / 2`
    fi
  fi

function build_uboot()
{
tooldir="$(dirname `pwd`)/out/${LICHEE_PLATFORM}/common/buildroot/external-toolchain"
  if [ -d ${tooldir} ] ; then
      if ! echo $PATH | grep -q "$tooldir" ; then
          export PATH=${tooldir}/bin:$PATH
      fi
  else
      echo "Please build buildroot first"
      exit 1
  fi

    case "$1" in
        clean)
            make distclean CROSS_COMPILE=${CROSS_COMPILE}
            ;;
        *)
            make distclean CROSS_COMPILE=${CROSS_COMPILE}
            make -j${jobs} ${LICHEE_CHIP} CROSS_COMPILE=${CROSS_COMPILE}
            [ $? -ne 0 ] && exit 1
            cp -f u-boot.bin ../out/${LICHEE_PLATFORM}/common/
            ;;
    esac
}

if [ $(basename `pwd`) != "u-boot" ] ; then
    echo "Please run at the top directory of u-boot"
    exit 1
fi

if [ -n "${LICHEE_CHIP}" ] ; then
    build_uboot $1
    exit 0
fi

. ../buildroot/scripts/shflags/shflags

# define option, format:
#   'long option' 'default value' 'help message' 'short option'
DEFINE_string 'platform' 'sun7i' 'platform to build, e.g. sun7i' 'p'
DEFINE_string 'board' '' 'board to build, e.g. evb' 'b'
DEFINE_string 'module' '' 'module to build, e.g. clean' 'm'

# parse the command-line
FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

LICHEE_CHIP=${FLAGS_platform%%_*}
LICHEE_PLATFORM=${FLAGS_platform##*_}
LICHEE_BOARD=${FLAGS_board}

if [ "${LICHEE_CHIP}" = "${LICHEE_PLATFORM}" ] ; then
    LICHEE_PLATFORM="linux"
fi

tooldir="$(dirname `pwd`)/out/${LICHEE_PLATFORM}/common/buildroot/external-toolchain"
if [ -d ${tooldir} ] ; then
    if ! echo $PATH | grep -q "$tooldir" ; then
        export PATH=${tooldir}/bin:$PATH
    fi
else
    echo "Please build buildroot first"
    exit 1
fi

build_uboot ${FLAGS_module}
