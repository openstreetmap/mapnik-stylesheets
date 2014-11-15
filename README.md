
#Old XML format Mapnik stylesheets for OpenStreetMap 'standard' style
--------------------------------------------------------------------


This used to be the development location of the Mapnik stylesheets
powering tile.openstreetmap.org however these XML format stylesheets
have since be superceded by new CartoCSS format stylesheets which
can be found here:

[https://github.com/gravitystorm/openstreetmap-carto](https://github.com/gravitystorm/openstreetmap-carto)

These old XML stylesheets are still used on some other tile servers.

This directory also holds an assortment of helpful utility scripts for
working with Mapnik and the OSM Mapnik XML stylesheets.

Scalable large-area serving is typically done using mod_tile

* Code is located at http://svn.openstreetmap.org/applications/utils/mod_tile.
* Rendering is done by the 'renderd' daemon (both a python and C++ version are available).

However, the easiest way to start rendering Mapnik tiles is to use the 
'generate_tiles.py' script located within this directory.


##Quick References
----------------
If you need additional info, please read:

- [http://wiki.openstreetmap.org/wiki/Mapnik](http://wiki.openstreetmap.org/wiki/Mapnik)

If you are new to Mapnik see:

 - [http://mapnik.org](http://mapnik.org)

If you are looking for an old file that used to be here see the 'archive' directory.



##Required
--------

Mapnik >= 2.0.0 | The rendering library

 * Built with the PostGIS plugin
 * [http://trac.mapnik.org/wiki/Mapnik-Installation](http://trac.mapnik.org/wiki/Mapnik-Installation)

osm2pgsql trunk | Tool for importing OSM data into PostGIS

 * The latest trunk source is highly recommended
 * [http://svn.openstreetmap.org/applications/utils/export/osm2pgsql](http://svn.openstreetmap.org/applications/utils/export/osm2pgsql)

Coastline Shapefiles

 * Download these locally
 * For more info see: [http://wiki.openstreetmap.org/wiki/Mapnik](http://wiki.openstreetmap.org/wiki/Mapnik)
 * They come with Mapnik indexes pre-built (using shapeindex)

Planet.osm data in PostGIS

 * An extract (recommended) or the whole thing
   - [http://wiki.openstreetmap.org/wiki/Planet.osm](http://wiki.openstreetmap.org/wiki/Planet.osm)
 * Import this into PostGIS with osm2pgsql



##Quickstart
----------

The goal is to customize the Mapnik stylesheets to your local setup,
test rendering a few images, and then get set up to render tiles.

First, make sure you have downloaded the coastlines shapefiles and have set up a
postgis enabled database with osm data imported using osm2pgsql. See
[http://wiki.openstreetmap.org/wiki/Mapnik](http://wiki.openstreetmap.org/wiki/Mapnik) for more info.

Then customize the xml entities (the files in the inc/ directory) which are
used by the 'osm.xml' to your setup. You can either use the 'generate_xml.py' 
script or manually edit a few files inside the 'inc' directory.

Finally try rendering a few maps using either 'generate_image.py',
'generate_tiles.py' or 'nik2img.py'.



##Downloading the Coastlines Shapefiles
-------------------------------------
 
   All these actions are regrouped in the script file get-coastlines.sh in this directory

    wget http://tile.openstreetmap.org/world_boundaries-spherical.tgz # (51M)
    wget http://tile.openstreetmap.org/processed_p.tar.bz2 # (391M)
    wget http://tile.openstreetmap.org/shoreline_300.tar.bz2 # (42M)
    wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places.zip # (1.5 MB)
    wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_boundary_lines_land.zip # (44 KB)

    tar xzf world_boundaries-spherical.tgz # creates a 'world_boundaries' folder
    tar xjf processed_p.tar.bz2 -C world_boundaries
    tar xjf shoreline_300.tar.bz2 -C world_boundaries
    unzip -q ne_10m_populated_places.zip -d world_boundaries
    unzip -q ne_110m_admin_0_boundary_lines_land.zip -d world_boundaries


##Using generate_xml.py
---------------------

To use the 'generate_xml.py' script simply run:

    ./generate_xml.py -h  # note the optional and required parameters

Most users will need to pass their database settings with something like:

    ./generate_xml.py --dbname osm --host 'localhost' --user postgres --port 5432 --password ''

If that command works, then you are ready to render tiles!

The script will also pick up ALLCAPS global environment settings (where they must have a 'MAPNIK" prefix):

    export MAPNIK_DBNAME=osm && export MAPNIK_HOST=localhost && ./generate_xml.py 

Note: Depending on your database configuration you may be able to leave empty values for
parameters such as 'host', 'port', 'password', or even 'dbname'.

Do do this can pass the '--accept-none' flag or empty strings:

    ./generate_xml.py --dbname osm --accept-none

    ./generate_xml.py --dbname osm --host '' --user '' --port '' --password ''`

Advanced users may want to create multiple versions of the Mapnik XML for various rendering
scenarios, and this can be done using 'generate_xml.py' by passing the 'osm.xml' as an argument
and then piping the resulting xml to a new file:

    ./generate_xml.py osm.xml > my_osm.xml



##Manually editing 'inc' files
----------------------------

To manually configure your setup you will need to work with the XML snippets 
in the 'inc' directory which end with 'template'.

Copy them to a new file and strip off the '.template' extension.

    cp inc/datasource-settings.xml.inc.template inc/datasource-settings.xml.inc
    cp inc/fontset-settings.xml.inc.template inc/fontset-settings.xml.inc
    cp inc/settings.xml.inc.template inc/settings.xml.inc

Then edit the settings variables (e.g. '%(value)s') in those files to match your configuration.
Details can be found in each file. Stick with the recommended defaults unless you know better.

##Troubleshooting
---------------

If trying to read the XML with Mapnik (or any of the python scripts included here that use Mapnik)
fails with an error like `XML document not well formed` or `Entity 'foo' not defined`, then try running
xmllint, which may provide a more detailed error to help you find the syntax problem in the XML (or its
referenced includes):

    xmllint osm.xml --noout

Not output from the above command indicates the stylesheet should be working fine.

If you see an error like: `warning: failed to load external entity "inc/datasource-settings.xml.inc"` then this
likely indicates that an include file is missing, which means that you forgot to follow the steps above to generate the needed includes on the fly either by using `generate_xml.py` or manually creating your inc files.


##Testing rendering
-----------------

To generate a simple image of the United Kingdom use the 'generate_image.py' script.


    ./generate_image.py # will output and 'image.png' file...


To try generating an image with the ability to zoom to different areas or output different formats
then try loading the XML using nik2img. Download and install nik2img using the
instructions from http://trac.mapnik.org/wiki/Nik2Img

To zoom to the same area as generate_image.py but at level 4 do:

    nik2img.py osm.xml image.png --center -2.2 54.25 --zoom 4

Advanced users may want to change settings and dynamically view result of the re-generated xml.

This can be accomplished by piping the XML to nik2img.py, for example:

    ./generate_xml.py osm.xml | nik2img.py test.png

Or, zoom into a specific layer's extent (useful when using a regional OSM extract):

    ./generate_xml.py --estimate_extent true --dbname osm osm.xml --accept-none | nik2img.py --zoom-to-layer roads roads.png



##Rendering tiles
---------------

You are now ready to test rendering tiles.

Edit the 'bbox' inside 'generate_tiles.py' and run

    ./generate_tiles.py

Alternatively, run

    ./polytiles.py --bbox X1 Y1 X2 Y2

Tiles will be written into 'tiles' directory. To see the list of all parameters,
run this script without any.

##Files and Directories
---------------------


all_tiles

* ???

convert

* OBSOLETE. Use customize-mapnik-map instead.

customize-mapnik-map

* Run this script to convert osm-template.xml into osm.xml with your
    settings.
    
generate_xml.py

* A script to help customize the osm.xml. Will read parameters from the
    users environment or via command line flags. Run ./generate_xml.py -h
    for usage and help.
    
generate_image.py

* A script to generate a map image from OSM data using Mapnik. Will
    read mapping instructions from $MAPNIK_MAP_FILE (or 'osm.xml') and
    write the finished map to 'image.png'. You have to change the script
    to change the bounding box or image size.

generate_tiles.py

* A script to generate map tiles from OSM data using Mapnik. Will
    read mapping instructions from $MAPNIK_MAP_FILE (or 'osm.xml') and
    write the finished maps to the $MAPNIK_TILE_DIR directory. You have
    to change the script to change the bounding boxes or zoom levels
    for which tiles are created.

polytiles.py

* An advanced script to generate map tiles with Mapnik. Can produce
    png files, .mbtiles or just a list. Supports not only bboxes,
    but PostGIS polygons, .poly files and tile lists. Run the script
    without parameters to see the full list of options.

install.txt

* An almost cut-and-paste documentation on how to use all this.

legend.py

* Script for generating a simple legend from osm-template.xml, useful
    for visualizing existing styles and changes.

mkshield.pl

* Perl script to generate highway shield images. You normally don't
    have to run this because prerendered images are already stored in
    the 'symbols' directory.

openstreetmap-mapnik-data

openstreetmap-mapnik-world-boundaries

* These directories contain the things needed to create Debian packages
    for OSM Mapnik stuff.

osm-template.xml

* A template for the osm.xml file which contains the rules on how
    Mapnik should render data.

osm.xml

* The file which contains the rules on how Mapnik should render data.
    You should generate your own version from the osm-template.xml file.

osm2pgsl.py

* Older script to read OSM data into a PostgreSQL/PostGIS database. Use
    the newer C version in ../../utils/export/osm2pgsql instead!

set-mapnik-env

* Used to customize the environment needed by the other Mapnik OSM
    scripts.

setup_z_order.sql

* SQL commands to set up Z order for rendering. This is included in
    the C version of osm2pgsql in ../../utils/export/osm2pgsql, so you
    don't need this any more.

symbols

* Directory with icons and highway shield images.

zoom-to-scale.txt

* Comparison between zoom levels and the scale denominator numbers needed
    for the Mapnik Map file.

