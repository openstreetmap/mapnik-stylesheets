#!/usr/bin/python
from math import pi,cos,sin,log,exp,atan
from subprocess import call
import sys, os

DEG_TO_RAD = pi/180
RAD_TO_DEG = 180/pi

def minmax (a,b,c):
    a = max(a,b)
    a = min(a,c)
    return a

class GoogleProjection:
    def __init__(self,levels=18):
        self.Bc = []
        self.Cc = []
        self.zc = []
        self.Ac = []
        c = 256
        for d in range(0,levels):
            e = c/2;
            self.Bc.append(c/360.0)
            self.Cc.append(c/(2 * pi))
            self.zc.append((e,e))
            self.Ac.append(c)
            c *= 2
                
    def fromLLtoPixel(self,ll,zoom):
         d = self.zc[zoom]
         e = round(d[0] + ll[0] * self.Bc[zoom])
         f = minmax(sin(DEG_TO_RAD * ll[1]),-0.9999,0.9999)
         g = round(d[1] + 0.5*log((1+f)/(1-f))*-self.Cc[zoom])
         return (e,g)
     
    def fromPixelToLL(self,px,zoom):
         e = self.zc[zoom]
         f = (px[0] - e[0])/self.Bc[zoom]
         g = (px[1] - e[1])/-self.Cc[zoom]
         h = RAD_TO_DEG * ( 2 * atan(exp(g)) - 0.5 * pi)
         return (f,h)

from mapnik import *

def render_tiles(bbox, mapfile, tile_dir, minZoom=1,maxZoom=18, name="unknown"):
    print "render_tiles(",bbox, mapfile, tile_dir, minZoom,maxZoom, name,")"

    if not os.path.isdir(tile_dir):
         os.mkdir(tile_dir)

    gprj = GoogleProjection(maxZoom+1) 
    m = Map(2 * 256,2 * 256)
    load_map(m,mapfile)
    prj = Projection("+proj=merc +datum=WGS84")
    
    ll0 = (bbox[0],bbox[3])
    ll1 = (bbox[2],bbox[1])
    
    for z in range(minZoom,maxZoom + 1):
        px0 = gprj.fromLLtoPixel(ll0,z)
        px1 = gprj.fromLLtoPixel(ll1,z)
        for x in range(int(px0[0]/256.0),int(px1[0]/256.0)+1):
            for y in range(int(px0[1]/256.0),int(px1[1]/256.0)+1):
                p0 = gprj.fromPixelToLL((x * 256.0, (y+1) * 256.0),z)
                p1 = gprj.fromPixelToLL(((x+1) * 256.0, y * 256.0),z)

                # render a new tile and store it on filesystem
                c0 = prj.forward(Coord(p0[0],p0[1]))
                c1 = prj.forward(Coord(p1[0],p1[1]))
            
                bbox = Envelope(c0.x,c0.y,c1.x,c1.y)
                bbox.width(bbox.width() * 2)
                bbox.height(bbox.height() * 2)
                m.zoom_to_box(bbox)
                
                # check if we have directories in place
                zoom = "%s" % z
                str_x = "%s" % x
                str_y = "%s" % y

                if not os.path.isdir(tile_dir + zoom):
                    os.mkdir(tile_dir + zoom)
                if not os.path.isdir(tile_dir + zoom + '/' + str_x):
                    os.mkdir(tile_dir + zoom + '/' + str_x)

                tile_uri = tile_dir + zoom + '/' + str_x + '/' + str_y + '.png'

		exists= ""
                if os.path.isfile(tile_uri):
                    exists= "exists"
                else:
                    im = Image(512, 512)
                    render(m, im)
                    view = im.view(128,128,256,256) # x,y,width,height
                    save_to_file(tile_uri,'png',view)
                    command = "convert  -colors 255 %s %s" % (tile_uri,tile_uri)
                    call(command, shell=True)

                bytes=os.stat(tile_uri)[6]
		empty= ''
                if bytes == 137:
                    empty = " Empty Tile "

                print name,"[",minZoom,"-",maxZoom,"]: " ,z,x,y,"p:",p0,p1,exists, empty

if __name__ == "__main__":
    home = os.environ['HOME']
    mapfile = home + "/svn.openstreetmap.org/applications/rendering/mapnik/osm-local.xml"
    tile_dir = home + "/osm/tiles/"

    # Start with an overview
    # World
    bbox = (-180.0,-90.0, 180.0,90.0)
    render_tiles(bbox, mapfile, tile_dir, 0, 5,"World")

    minZoom = 10
    maxZoom = 16
    bbox = (-2, 50.0,1.0,52.0)
    render_tiles(bbox, mapfile, tile_dir, minZoom, maxZoom)


    # Muenchen
    bbox = (11.4,48.07, 11.7,48.22)
    render_tiles(bbox, mapfile, tile_dir, 1, 12 , "Muenchen")


    # Muenchen+
    bbox = (11.3,48.01, 12.15,48.44)
    render_tiles(bbox, mapfile, tile_dir, 7, 12 , "Muenchen+")

    # Muenchen++
    bbox = (10.92,47.7, 12.24,48.61)
    render_tiles(bbox, mapfile, tile_dir, 7, 12 , "Muenchen++")

    # Nuernberg
    bbox=(10.903198,49.560441,49.633534,11.038085)
    render_tiles(bbox, mapfile, tile_dir, 10, 16,"Nuernberg")

    # Karlsruhe
    bbox=(8.179113,48.933617,8.489252,49.081707)
    render_tiles(bbox, mapfile, tile_dir, 10, 16,"Karlsruhe")

    # Karlsruhe+
    bbox = (8.3,48.95,8.5,49.05)
    render_tiles(bbox, mapfile, tile_dir, 1, 16, "Karlsruhe+")

    # Augsburg
    bbox = (8.3,48.95,8.5,49.05)
    render_tiles(bbox, mapfile, tile_dir, 1, 16, "Augsburg")

    # Augsburg+
    bbox=(10.773251,48.369594,10.883834,48.438577)
    render_tiles(bbox, mapfile, tile_dir, 10, 14, "Augsburg+")

    # Europe+
    bbox = (1.0,10.0, 20.6,50.0)
    render_tiles(bbox, mapfile, tile_dir, 1, 11 , "Europe+")

    # World
    bbox = (-180.0,-90.0, 180.0,90.0)
    render_tiles(bbox, mapfile, tile_dir, 1, 6,"World")
