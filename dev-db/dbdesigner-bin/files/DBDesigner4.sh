#!/bin/sh
DIR=$(dirname $0)
mkdir -p ~/.DBDesigner4
## QT smooth fonts
#QT_XFT=true \
## use the original qt files
#CLX_USE_LIBQT=yes \
LD_LIBRARY_PATH=${DIR}/Linuxlib/:$LD_LIBRARY_PATH \
exec ${DIR}/DBDesigner4 $* 2>&1 >~/.DBDesigner4/DBD4.log
