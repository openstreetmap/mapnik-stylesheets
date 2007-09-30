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


echo "check if we already have an user '$user_name'"

if ! id "$user_name" ; then
    echo "create '$user_name' User"
    useradd "$user_name"
fi

mkdir -p "/home/$user_name/osm/planet"
chown -R "$user_name" "/home/$user_name"
chmod -R +rwX "/home/$user_name"


echo "mirroring planet File"
if ! sudo -u "$user_name" osm-planet-mirror -v -v --planet-dir=$planet_dir ; then 
    echo "Cannot Mirror Planet File"
    exit
fi

echo "------- Drop complete Database '$database_name'"
sudo -u postgres dropdb -Upostgres   "$database_name"
sudo -u postgres dropuser -Upostgres "$user_name"

echo
echo "# ----------- Create Database '$database_name'"
sudo -u postgres createuser -Upostgres  -q -S -D -R "$user_name"  || exit -1 
sudo -u postgres createdb -Upostgres  -q  -EUTF8 "$database_name"  || exit -1 
sudo -u postgres createlang plpgsql "$database_name"  || exit -1 
sudo -u postgres psql -q -Upostgres "$database_name" </usr/share/postgresql-8.2-postgis/lwpostgis.sql 

echo 
echo "# ----------- Grant rights on Database '$database_name' for '$user_name'"
(
    echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user_name\";" 
    echo "GRANT ALL on geometry_columns TO \"$user_name\";"
    echo "GRANT ALL on spatial_ref_sys TO \"$user_name\";" 
    echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user_name\";" 
) | sudo -u postgres psql -q -Upostgres "$database_name"

echo ""
echo "--------- Unpack and import $planet_file"
sudo -u "$user_name" osm2pgsql $planet_file
