#!/bin/sh

# Copyright (C) 2010 Rodolphe Quiédeville <rodolphe@quiedeville.org> 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

UNZIP=/usr/bin/unzip
TAR=/bin/tar
BUNZIP2=/bin/bunzip2
WGET=/usr/bin/wget

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

if [ ! -x $WGET ]; then
    echo "wget is not installed in $WGET, it is needed by this script"
    exit
fi

$WGET http://tile.openstreetmap.org/world_boundaries-spherical.tgz -O world_boundaries-spherical.tgz
$WGET http://tile.openstreetmap.org/processed_p.tar.bz2 -O processed_p.tar.bz2
$WGET http://tile.openstreetmap.org/shoreline_300.tar.bz2 -O shoreline_300.tar.bz2
$WGET http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/10m-populated-places.zip -O 10m-populated-places.zip
$WGET http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/110m-admin-0-boundary-lines.zip -O 110m-admin-0-boundary-lines.zip

$TAR xvf world_boundaries-spherical.tgz

if [ -d world_boundaries ]; then

	if [ -f processed_p.tar.bz2 ]; then
		$TAR xvf processed_p.tar.bz2
		mv processed_p.[dis]* world_boundaries/
	else
		echo 'processed_p.tar.bz2 not present'
	fi

	if [ -f shoreline_300.tar.bz2 ]; then
		$TAR xvf shoreline_300.tar.bz2
		mv shoreline_300.[dis]* world_boundaries/
	else
		echo 'shoreline_300.tar.bz2 not present'
	fi

	if [ -f 10m-populated-places.zip ]; then
		$UNZIP 10m-populated-places.zip -d world_boundaries
	else
		echo '10m-populated-places.zip not present'
	fi

	if [ -f 110m-admin-0-boundary-lines.zip ]; then
		$UNZIP 110m-admin-0-boundary-lines.zip -d world_boundaries
	else
		echo '110m-admin-0-boundary-lines.zip not present'
	fi

fi
