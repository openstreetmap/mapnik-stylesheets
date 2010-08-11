#!/bin/sh

UNZIP=/usr/bin/unzip
TAR=/bin/tar
BUNZIP2=/bin/bunzip2

if [ ! -x $UNZIP ]; then
    echo "unzip is not installed in $UNZIP, it is needed by this script"
    exit
fi

if [ ! -x $TAR ]; then
    echo "tar is not installed in $TAR, it is needed by this script"
    exit
fi

if [ ! -x $BUNZIP2 ]; then
    echo "bunzip2 is not installed in $BUNZIP2, it is needed by this script"
    exit
fi


wget http://tile.openstreetmap.org/world_boundaries-spherical.tgz -O world_boundaries-spherical.tgz
wget http://tile.openstreetmap.org/processed_p.tar.bz2 -O processed_p.tar.bz2
wget http://tile.openstreetmap.org/shoreline_300.tar.bz2 -O shoreline_300.tar.bz2
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-populated-places.zip -O 10m-populated-places.zip
wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m-admin-0-boundary-lines.zip -O 110m-admin-0-boundary-lines.zip

tar xvf world_boundaries-spherical.tgz

if [ -d world_boundaries ]; then

	if [ -f processed_p.tar.bz2 ]; then
		tar xvf processed_p.tar.bz2
		mv processed_p.[dis]* world_boundaries/
	else
		echo 'processed_p.tar.bz2 not present'
	fi

	if [ -f shoreline_300.tar.bz2 ]; then
		tar xvf shoreline_300.tar.bz2
		mv shoreline_300.[dis]* world_boundaries/
	else
		echo 'shoreline_300.tar.bz2 not present'
	fi

	if [ -f 10m-populated-places.zip ]; then
		unzip 10m-populated-places.zip -d world_boundaries
	else
		echo '10m-populated-places.zip not present'
	fi

	if [ -f 110m-admin-0-boundary-lines.zip ]; then
		unzip 110m-admin-0-boundary-lines.zip -d world_boundaries
	else
		echo '110m-admin-0-boundary-lines.zip not present'
	fi

fi
