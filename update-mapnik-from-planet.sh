#!/bin/bash

export user_name="osm"
export database_name="gis"
export planet_dir="/home/$user_name/osm/planet"
export planet_file="$planet_dir/planet.osm.bz2"

test -n "$1" || help=1
quiet=" -q "
verbose=1

for arg in "$@" ; do
    case $arg in
	--all-planet) #		Do all the creation steps listed below from planet file
	    create_user=1
	    mirror=1
	    drop=1
	    create_db=1
	    create_db_user=1
	    grant_all_rights_to_user_osm=1
	    planet_fill=1
	    create_db_users=${create_db_users:-*}
	    ;;

	--create_user) #	create the user needed
	    create_user=1
	    ;;
	
	--mirror) #		mirror the planet File
	    mirror=1
	    ;;

	--drop) #		drop the old Database and Database-user
	    drop=1
	    ;;

	--create_db) #		create the database and db-user
	    create_db=1
	    ;;
	
	--create_db_user) #	create the database and db-user
	    create_db_user=1
	    ;;
	
	--grant_all_rights_to_user_osm) #	grant all rights to the osm User	
	    grant_all_rights_to_user_osm=1
	    ;;

	--create_db_users=*) #Create a Database user for all users specified.
	    #		To use all available on the system specify *. (Except root)
	    create_db_users=${arg#*=}
	    ;;
	
	--grant_db_users=*) #	Grant database-users all rights (including write, ...) to the gis Database
	    grant_db_users=${arg#*=}
	    ;;

	--planet_fill) #	fill database from planet File
	    planet_fill=1
	    ;;

	--postgis_mapnik_dump=*) #	Dump Content of Mapnik postgis Database to a file File (*.sql or *.sql.bz)
	    postgis_mapnik_dump=${arg#*=}
	    ;;
	
	--db_table_create) #	Create tables in Database with osm2pgsql
	    db_table_create=1
	    ;;
	
	-h)
	    help=1
	    ;;

	--help)
	    help=1
	    ;;

	-help)
	    help=1
	    ;;

	--debug) #		switch on debugging
	    debug=1
	    verbose=1
	    quiet=""
	    ;;

	-debug)
	    debug=1
	    verbose=1
	    quiet=""
	    ;;
	

	--nv) #			be a little bit less verbose
	    verbose=''
	    ;;

	--planet_dir=*) #	define Directory for Planet-File
	    planet_dir=${arg#*=}
	    planet_file="$planet_dir/planet.osm.bz2"
	    ;;

	--planet_file=*) #	define Directory for Planet-File
	    planet_file=${arg#*=}
	    ;;
	
	--user_name=*) #	Define username to use for DB creation
	    user_name=${arg#*=}
	    planet_dir="/home/$user_name/osm/planet"
	    planet_file="$planet_dir/planet.osm.bz2"
	    ;;
	
	--database_name=*) #	use this name for the database
	    database_name=${arg#*=}
	    ;;

	*)
	    echo "Unknown option $arg"
	    help=1
	    ;;
    esac
done

if [ -n "$help" ] ; then
    # extract options from case commands above
    options=`grep -E -e esac -e '\s*--.*\).*#' $0 | sed '/esac/,$d;s/.*--/ [--/; s/=\*)/=val]/; s/)[\s ]/]/; s/#.*\s*//; s/[\n/]//g;'`
    options=`for a in $options; do echo -n " $a" ; done`
    echo "$0 $options"
    echo "
!!! Warning: This Script is for now a quick hack to make setting up
!!! Warning: My databases easier. Please check if it really works for you!!
!!! Warning: Especially when using different Database names or username, ...

    This script tries to install the mapnik database.
    For this it first creates a new user osm on the system
    and mirrors the current planet to his home directory.
    Then this planet is imported into the postgis Database from a 
    newly created user named osm
    "
    # extract options + description from case commands above
    grep -E  -e esac -e '--.*\).*#' -e '^[\t\s 	]*#' $0 | grep -v /bin/bash | sed '/esac/,$d;s/.*--/  --/;s/=\*)/=val/;s/)//;s/#//;' 
    exit;
fi

############################################
# Create a user on the system
############################################
if [ -n "$create_user" ] ; then
    test -n "$verbose" && echo "----- Check if we already have an user '$user_name'"
    
    if ! id "$user_name" >/dev/null; then
	echo "create '$user_name' User"
	useradd "$user_name"
    fi
    
    mkdir -p "/home/$user_name/osm/planet"
    chown -R "$user_name" "/home/$user_name"
    chmod -R +rwX "/home/$user_name"
fi


############################################
# Mirror the planet File from planet.openstreetmao.org
############################################
if [ -n "$mirror" ] ; then
    test -n "$verbose" && echo "----- Mirroring planet File"
    if ! sudo -u "$user_name" osm-planet-mirror -v -v --planet-dir=$planet_dir ; then 
	echo "Cannot Mirror Planet File"
	exit
    fi
fi

############################################
# Drop the old Database and Database-user
############################################
if [ -n "$drop" ] ; then
    test -n "$verbose" && echo "----- Drop complete Database '$database_name' and user '$user_name'"
    echo "CHECKPOINT" | sudo -u postgres psql $quiet
    sudo -u postgres dropdb $quiet -Upostgres   "$database_name"
    sudo -u postgres dropuser $quiet -Upostgres "$user_name"
fi

############################################
# Create db
############################################
if [ -n "$create_db" ] ; then
    test -n "$verbose" && echo
    test -n "$verbose" && echo "----- Create Database '$database_name'"
    sudo -u postgres createdb -Upostgres  $quiet  -EUTF8 "$database_name"  || exit -1 
    sudo -u postgres createlang plpgsql "$database_name"  || exit -1 
    sudo -u postgres psql $quiet -Upostgres "$database_name" </usr/share/postgresql-8.2-postgis/lwpostgis.sql 
fi

############################################
# Create db-user
############################################
if [ -n "$create_db_user" ] ; then
    test -n "$verbose" && echo "----- Create Database-user '$user_name'"
    sudo -u postgres createuser -Upostgres  $quiet -S -D -R "$user_name"  || exit -1 
fi

if [ -n "$grant_all_rights_to_user_osm" ] ; then
    test -n "$verbose" && echo 
    test -n "$verbose" && echo "----- Grant rights on Database '$database_name' for '$user_name'"
    (
	echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user_name\";" 
	echo "GRANT ALL on geometry_columns TO \"$user_name\";"
	echo "GRANT ALL on spatial_ref_sys TO \"$user_name\";" 
	echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user_name\";" 
    ) | sudo -u postgres psql $quiet -Upostgres "$database_name"
fi

############################################
# Create a Database user for all users specified (*) or available on the system. Except root
############################################
if [ -n "$create_db_users" ] ; then

    if [ "$create_db_users" = "*" ] ; then
        echo "GRANT Rights to every USER"
        create_db_users=''
        for user in `users|grep -v -e root` ; do 
            create_db_users="$create_db_users $user"
        done
    fi

    for user in $create_db_users; do
        sudo -u postgres createuser $quiet -Upostgres --no-superuser --no-createdb --no-createrole "$user"
    done
fi

############################################
# Grant all rights on the gis Database to all system users or selected users in the system
############################################
if [ -n "$grant_db_users" ] ; then

    if [ "$grant_db_users" = "*" ] ; then
        echo "GRANT Rights to every USER"
        grant_db_users=''
        for user in `users` ; do 
	    echo "$user" | grep -q "root" && continue
	    echo " $grant_db_users " | grep -q " $user " && continue
            grant_db_users="$grant_db_users $user"
        done
    fi

    test -n "$verbose" && echo "Granting rights to users: '$grant_db_users'"

    for user in $grant_db_users; do
        echo "Granting all rights to user '$user' for Database '$database_name'"
        (
            echo "GRANT ALL on geometry_columns TO \"$user\";"
            echo "GRANT ALL ON SCHEMA PUBLIC TO \"$user\";"
            echo "GRANT ALL on spatial_ref_sys TO \"$user\";"
            )| sudo -u postgres psql $quiet -Upostgres "$database_name" || true
    done
fi


############################################
# Create Database tables with osm2pgsql
############################################
if [ -n "$db_table_create" ] ; then
    echo ""
    echo "--------- Unpack and import $planet_file"
    sudo -u "$user_name" osm2pgsql --create "$database_name"
fi

############################################
# Fill Database from planet File
############################################
if [ -n "$planet_fill" ] ; then
    echo ""
    echo "--------- Unpack and import $planet_file"
    sudo -u "$user_name" osm2pgsql --database "$database_name" $planet_file
fi


############################################
# Dump the complete Database
############################################
if [ -n "$postgis_mapnik_dump" ] ; then
	# get Database Content with Dump
    postgis_mapnik_dump_dir=`dirname $postgis_mapnik_dump`
	mkdir -p "$postgis_mapnik_dump_dir"
	case "$postgis_mapnik_dump" in
	    *.gz)
		sudo -u "$user_name" pg_dump -U "$user_name" "$database_name" | gzip >"$postgis_mapnik_dump"
		;;
	    *)
		sudo -u "$user_name" pg_dump -U "$user_name" "$database_name" >"$postgis_mapnik_dump"
		;;
	esac
fi