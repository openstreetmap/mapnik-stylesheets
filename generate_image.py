#!/usr/bin/python
#
# Generates a single large PNG image for a UK bounding box
# Tweak the lat/lon bounding box (ll) and image dimensions
# to get an image of arbitrary size.
#
# To use this script you must first have installed mapnik
# and imported a planet file into a Postgres DB using
# osm2pgsql.
#
# Note that mapnik renders data differently depending on
# the size of image. More detail appears as the image size
# increases but note that the text is rendered at a constant
# pixel size so will appear smaller on a large image.

from mapnik import *
import sys, os

if __name__ == "__main__":
    try:
        mapfile = os.environ['MAPNIK_MAP_FILE']
    except KeyError:
        mapfile = "osm.xml"
    map_uri = "image.png"

    #---------------------------------------------------
    #  Change this to the bounding box you want
    #
    ll = (-6.5, 49.5, 2.1, 59)
    #---------------------------------------------------

    z = 10
    imgx = 500 * z
    imgy = 1000 * z

    m = Map(imgx,imgy)
    load_map(m,mapfile)
    prj = Projection("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs +over")
    c0 = prj.forward(Coord(ll[0],ll[1]))
    c1 = prj.forward(Coord(ll[2],ll[3]))
    bbox = Envelope(c0.x,c0.y,c1.x,c1.y)
    m.zoom_to_box(bbox)
    im = Image(imgx,imgy)
    render(m, im)
    view = im.view(0,0,imgx,imgy) # x,y,width,height
    save_to_file(map_uri,'png',view)
