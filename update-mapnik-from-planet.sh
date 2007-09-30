#!/bin/bash
# This script tries to install the mapnik database.
# For this it first creates a new user osm on the system
# and mirrors the current planet to his home directory.
# Then this planet is imported into the postgis Database from a 
# newly created user named osm

echo "Create postgis database from planet dump"

planet_dir=/home/osm/osm/planet
planet_file=$planet_dir/planet.osm.bz2
export user_name="osm"
export database_name="gis"


echo "check if we already have an osm user"

if ! id osm ; then
    echo "create osm User"
    useradd osm
fi

mkdir -p /home/osm/osm/planet
chown -R osm /home/osm
chmod -R +rwX /home/osm


echo "mirroring planet File"
if ! sudo -u osm osm-planet-mirror -v -v --planet-dir=$planet_dir ; then 
    echo "Cannot Mirror Planet File"
    exit
fi

echo "------- Drop complete Database"	
sudo -u postgres dropdb -Upostgres   "$database_name"
sudo -u postgres dropuser -Upostgres "$user_name"

echo
echo "# ----------- Create Database"
sudo -u postgres createuser -Upostgres -S -D -R "$user_name"  || exit -1 
sudo -u postgres createdb -Upostgres  -EUTF8 "$database_name"  || exit -1 
sudo -u postgres createlang plpgsql "$database_name"  || exit -1 
sudo -u postgres psql -Upostgres "$database_name" </usr/share/postgresql-8.2-postgis/lwpostgis.sql \
    2>&1 | grep -v -E \
    -e '^CREATE AGGREGATE$' \
    -e '^CREATE FUNCTION$' \
    -e '^CREATE OPERATOR CLASS$' \
    -e '^CREATE OPERATOR$' \
    -e '^UPDATE 1$' \
    -e '^CREATE CAST$' \
    -e '^COMMIT$' \
    -e '^CREATE TYPE$'

echo 
echo "# ----------- Create Database and Grant rights"
(
    echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user_name\";" 
    echo "GRANT ALL on geometry_columns TO \"$user_name\";"
    echo "GRANT ALL on spatial_ref_sys TO \"$user_name\";" 
    echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user_name\";" 
) | sudo -u postgres psql -Upostgres "$database_name"

echo ""
echo "--------- Unpack and import $planet_file"
sudo -u osm osm2pgsql $planet_file
