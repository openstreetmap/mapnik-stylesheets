#!/bin/sh

wget http://tile.openstreetmap.org/world_boundaries-spherical.tgz -O world_boundaries-spherical.tgz
wget http://tile.openstreetmap.org/processed_p.tar.bz2- O processed_p.tar.bz2
wget http://tile.openstreetmap.org/shoreline_300.tar.bz2 -O shoreline_300.tar.bz2
    
tar xvf world_boundaries-spherical.tgz

if [ -d world_boundaries ]; then

if [ -f processed_p.tar.bz2]; then
    tar xvf processed_p.tar.bz2
    mv processed_p.[dis]* world_boundaries/
else
    echo 'processed_p.tar.bz2 not present'
fi

if [ -f shoreline_300.tar.bz2]; then
    tar xvf shoreline_300.tar.bz2
    mv shoreline_300.[dis]** world_boundaries/
fi

fi
