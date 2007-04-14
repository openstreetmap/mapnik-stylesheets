

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- $Id: lwpostgis.sql.in 2406 2006-07-07 13:56:52Z strk $
--
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.refractions.net
-- Copyright 2001-2003 Refractions Research Inc.
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--  
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- WARNING: Any change in this file must be evaluated for compatibility.
--          Changes cleanly handled by lwpostgis_uptrade.sql are fine,
--	    other changes will require a bump in Major version.
--	    Currently only function replaceble by CREATE OR REPLACE
--	    are cleanly handled.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -






BEGIN;

-------------------------------------------------------------------
--  HISTOGRAM2D TYPE (lwhistogram2d)
-------------------------------------------------------------------


CREATE OR REPLACE FUNCTION histogram2d_in(cstring)
	RETURNS histogram2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwhistogram2d_in'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION histogram2d_out(histogram2d)
	RETURNS cstring
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwhistogram2d_out'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE TYPE histogram2d (
	alignment = double,
	internallength = variable,
	input = histogram2d_in,
	output = histogram2d_out,
	storage = main
);

-------------------------------------------------------------------
--  SPHEROID TYPE
-------------------------------------------------------------------


CREATE OR REPLACE FUNCTION spheroid_in(cstring)
	RETURNS spheroid
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','ellipsoid_in'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION spheroid_out(spheroid)
	RETURNS cstring
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','ellipsoid_out'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE TYPE spheroid (
	alignment = double,
	internallength = 65,
	input = spheroid_in,
	output = spheroid_out
);

-------------------------------------------------------------------
--  GEOMETRY TYPE (lwgeom)
-------------------------------------------------------------------


CREATE OR REPLACE FUNCTION geometry_in(cstring)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_in'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_out(geometry)
        RETURNS cstring
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_out'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_analyze(internal)
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_analyze'
	LANGUAGE 'C' VOLATILE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_recv(internal)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_recv'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_send(geometry)
	RETURNS bytea
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_send'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);


CREATE TYPE geometry (
        internallength = variable,
        input = geometry_in,
        output = geometry_out,
	send = geometry_send,
	receive = geometry_recv,
	delimiter = ':',
	analyze = geometry_analyze,
        storage = main
);

-------------------------------------------
-- Affine transforms
-------------------------------------------

-- Availability: 1.1.2
CREATE OR REPLACE FUNCTION Affine(geometry,float8,float8,float8,float8,float8,float8,float8,float8,float8,float8,float8,float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_affine'
	LANGUAGE 'C' IMMUTABLE STRICT; 

-- Availability: 1.1.2
CREATE OR REPLACE FUNCTION Affine(geometry,float8,float8,float8,float8,float8,float8)
	RETURNS geometry
	AS 'SELECT affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

-- Availability: 1.1.2
CREATE OR REPLACE FUNCTION RotateZ(geometry,float8)
	RETURNS geometry
	AS 'SELECT affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

-- Availability: 1.1.2
CREATE OR REPLACE FUNCTION Rotate(geometry,float8)
	RETURNS geometry
	AS 'SELECT rotateZ($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

-- Availability: 1.1.2
CREATE OR REPLACE FUNCTION RotateX(geometry,float8)
	RETURNS geometry
 	AS 'SELECT affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

-- Availability: 1.1.2
CREATE OR REPLACE FUNCTION RotateY(geometry,float8)
	RETURNS geometry
 	AS 'SELECT affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

CREATE OR REPLACE FUNCTION Translate(geometry,float8,float8,float8)
	RETURNS geometry
 	AS 'SELECT affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

CREATE OR REPLACE FUNCTION Translate(geometry,float8,float8)
	RETURNS geometry
	AS 'SELECT translate($1, $2, $3, 0)'
	LANGUAGE 'SQL' IMMUTABLE STRICT;

-- Availability: 1.1.0
CREATE OR REPLACE FUNCTION Scale(geometry,float8,float8,float8)
	RETURNS geometry
	AS 'SELECT affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

-- Availability: 1.1.0
CREATE OR REPLACE FUNCTION Scale(geometry,float8,float8)
	RETURNS geometry
	AS 'SELECT scale($1, $2, $3, 1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; 

-- Availability: 1.1.0 
CREATE OR REPLACE FUNCTION transscale(geometry,float8,float8,float8,float8)
        RETURNS geometry
        AS 'SELECT affine($1,  $4, 0, 0,  0, $5, 0, 
		0, 0, 1,  $2 * $4, $3 * $5, 0)'
        LANGUAGE 'SQL' IMMUTABLE STRICT;

-- Availability: 1.1.0
CREATE OR REPLACE FUNCTION shift_longitude(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_longitude_shift'
	LANGUAGE 'C' IMMUTABLE STRICT; 


        
-------------------------------------------------------------------
--  BOX3D TYPE
-------------------------------------------------------------------


CREATE OR REPLACE FUNCTION box3d_in(cstring)
	RETURNS box3d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX3D_in'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION box3d_out(box3d)
	RETURNS cstring
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX3D_out'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE TYPE box3d (
	alignment = double,
	internallength = 48,
	input = box3d_in,
	output = box3d_out
);

CREATE OR REPLACE FUNCTION xmin(box3d)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_xmin'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION ymin(box3d)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_ymin'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION zmin(box3d)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_zmin'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION xmax(box3d)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_xmax'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION ymax(box3d)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_ymax'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION zmax(box3d)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_zmax'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-------------------------------------------------------------------
--  CHIP TYPE
-------------------------------------------------------------------


CREATE OR REPLACE FUNCTION chip_in(cstring)
	RETURNS chip
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_in'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION chip_out(chip)
	RETURNS cstring
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_out'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE TYPE chip (
	alignment = double,
	internallength = variable,
	input = chip_in,
	output = chip_out,
	storage = extended
);

-----------------------------------------------------------------------
-- BOX2D
-----------------------------------------------------------------------



CREATE OR REPLACE FUNCTION box2d_in(cstring)
        RETURNS box2d
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX2DFLOAT4_in'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_out(box2d)
        RETURNS cstring
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX2DFLOAT4_out'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE TYPE box2d (
        internallength = 16,
        input = box2d_in,
        output = box2d_out,
        storage = plain
);

---- BOX2D  support functions


CREATE OR REPLACE FUNCTION box2d_overleft(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_overleft'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_overright(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_overright' 
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_left(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_left' 
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_right(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_right' 
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_contain(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_contain'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_contained(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_contained'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_overlap(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_overlap'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_same(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_same'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d_intersects(box2d, box2d) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2D_intersects'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- lwgeom  operator support functions

-------------------------------------------------------------------
-- BTREE indexes
-------------------------------------------------------------------

CREATE OR REPLACE FUNCTION geometry_lt(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwgeom_lt'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_le(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwgeom_le'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_gt(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwgeom_gt'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_ge(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwgeom_ge'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_eq(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwgeom_eq'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION geometry_cmp(geometry, geometry) 
	RETURNS integer
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'lwgeom_cmp'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

--
-- Sorting operators for Btree
--

CREATE OPERATOR < (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_lt,
   COMMUTATOR = '>', NEGATOR = '>=',
   RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR <= (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_le,
   COMMUTATOR = '>=', NEGATOR = '>',
   RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR = (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_eq,
   COMMUTATOR = '=', -- we might implement a faster negator here
   RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR >= (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_ge,
   COMMUTATOR = '<=', NEGATOR = '<',
   RESTRICT = contsel, JOIN = contjoinsel
);
CREATE OPERATOR > (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_gt,
   COMMUTATOR = '<', NEGATOR = '<=',
   RESTRICT = contsel, JOIN = contjoinsel
);


CREATE OPERATOR CLASS btree_geometry_ops
	DEFAULT FOR TYPE geometry USING btree AS
	OPERATOR	1	< ,
	OPERATOR	2	<= ,
	OPERATOR	3	= ,
	OPERATOR	4	>= ,
	OPERATOR	5	> ,
	FUNCTION	1	geometry_cmp (geometry, geometry);



-------------------------------------------------------------------
-- GiST indexes
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION postgis_gist_sel (internal, oid, internal, int4)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_gist_sel'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION postgis_gist_joinsel(internal, oid, internal, smallint)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_gist_joinsel'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION geometry_overleft(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_overleft'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_overright(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_overright'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_overabove(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_overabove'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_overbelow(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_overbelow'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_left(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_left'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_right(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_right'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_above(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_above'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_below(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_below'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_contain(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_contain'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_contained(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_contained'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_overlap(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_overlap'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry_same(geometry, geometry) 
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_same'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- GEOMETRY operators

CREATE OPERATOR << (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_left,
   COMMUTATOR = '>>',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR &< (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_overleft,
   COMMUTATOR = '&>',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR <<| (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_below,
   COMMUTATOR = '|>>',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR &<| (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_overbelow,
   COMMUTATOR = '|&>',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR && (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_overlap,
   COMMUTATOR = '&&',
   RESTRICT = postgis_gist_sel, JOIN = postgis_gist_joinsel
);

CREATE OPERATOR &> (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_overright,
   COMMUTATOR = '&<',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR >> (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_right,
   COMMUTATOR = '<<',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR |&> (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_overabove,
   COMMUTATOR = '&<|',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR |>> (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_above,
   COMMUTATOR = '<<|',
   RESTRICT = positionsel, JOIN = positionjoinsel
);

CREATE OPERATOR ~= (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_same,
   COMMUTATOR = '~=', 
   RESTRICT = eqsel, JOIN = eqjoinsel
);

CREATE OPERATOR @ (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_contained,
   COMMUTATOR = '~',
   RESTRICT = contsel, JOIN = contjoinsel
);

CREATE OPERATOR ~ (
   LEFTARG = geometry, RIGHTARG = geometry, PROCEDURE = geometry_contain,
   COMMUTATOR = '@',
   RESTRICT = contsel, JOIN = contjoinsel
);

-- gist support functions


CREATE OR REPLACE FUNCTION LWGEOM_gist_consistent(internal,geometry,int4) 
	RETURNS bool 
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1' ,'LWGEOM_gist_consistent'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION LWGEOM_gist_compress(internal) 
	RETURNS internal 
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_gist_compress'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION LWGEOM_gist_penalty(internal,internal,internal) 
	RETURNS internal 
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1' ,'LWGEOM_gist_penalty'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION LWGEOM_gist_picksplit(internal, internal) 
	RETURNS internal 
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1' ,'LWGEOM_gist_picksplit'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION LWGEOM_gist_union(bytea, internal) 
	RETURNS internal 
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1' ,'LWGEOM_gist_union'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION LWGEOM_gist_same(box2d, box2d, internal) 
	RETURNS internal 
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1' ,'LWGEOM_gist_same'
	LANGUAGE 'C';

CREATE OR REPLACE FUNCTION LWGEOM_gist_decompress(internal) 
	RETURNS internal
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1' ,'LWGEOM_gist_decompress'
	LANGUAGE 'C';

-------------------------------------------
-- GIST opclass index binding entries.
-------------------------------------------


--
-- Create opclass index bindings for PG>=73
--

CREATE OPERATOR CLASS gist_geometry_ops
        DEFAULT FOR TYPE geometry USING gist AS
        OPERATOR        1        << 	RECHECK,
        OPERATOR        2        &<	RECHECK,
        OPERATOR        3        &&	RECHECK,
        OPERATOR        4        &>	RECHECK,
        OPERATOR        5        >>	RECHECK,
        OPERATOR        6        ~=	RECHECK,
        OPERATOR        7        ~	RECHECK,
        OPERATOR        8        @	RECHECK,
	OPERATOR	9	 &<|	RECHECK,
	OPERATOR	10	 <<|	RECHECK,
	OPERATOR	11	 |>>	RECHECK,
	OPERATOR	12	 |&>	RECHECK,
	FUNCTION        1        LWGEOM_gist_consistent (internal, geometry, int4),
        FUNCTION        2        LWGEOM_gist_union (bytea, internal),
        FUNCTION        3        LWGEOM_gist_compress (internal),
        FUNCTION        4        LWGEOM_gist_decompress (internal),
        FUNCTION        5        LWGEOM_gist_penalty (internal, internal, internal),
        FUNCTION        6        LWGEOM_gist_picksplit (internal, internal),
        FUNCTION        7        LWGEOM_gist_same (box2d, box2d, internal);

UPDATE pg_opclass 
	SET opckeytype = (SELECT oid FROM pg_type 
                          WHERE typname = 'box2d' 
                          AND typnamespace = (SELECT oid FROM pg_namespace 
                                              WHERE nspname=current_schema())) 
	WHERE opcname = 'gist_geometry_ops' 
        AND opcnamespace = (SELECT oid from pg_namespace 
                            WHERE nspname=current_schema());
	
-- TODO: add btree binding...

	
-------------------------------------------
-- other lwgeom functions
-------------------------------------------

CREATE OR REPLACE FUNCTION addBBOX(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_addBBOX'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION dropBBOX(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_dropBBOX'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

	
CREATE OR REPLACE FUNCTION getSRID(geometry) 
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_getSRID'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION getBBOX(geometry)
        RETURNS box2d
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_to_BOX2DFLOAT4'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-------------------------------------------
--- CHIP functions
-------------------------------------------

CREATE OR REPLACE FUNCTION srid(chip)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_getSRID'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION height(chip)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_getHeight'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION factor(chip)
	RETURNS FLOAT4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_getFactor'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION width(chip)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_getWidth'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION datatype(chip)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_getDatatype'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION compression(chip)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_getCompression'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION setSRID(chip,int4)
	RETURNS chip
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_setSRID'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION setFactor(chip,float4)
	RETURNS chip
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_setFactor'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

------------------------------------------------------------------------
-- DEBUG
------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION mem_size(geometry)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_mem_size'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION summary(geometry)
	RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_summary'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION npoints(geometry)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_npoints'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION nrings(geometry)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_nrings'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

------------------------------------------------------------------------
-- Misures
------------------------------------------------------------------------

-- this is a fake (for back-compatibility)
-- uses 3d if 3d is available, 2d otherwise
CREATE OR REPLACE FUNCTION length3d(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_length_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION length2d(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_length2d_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION length(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_length_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-- this is a fake (for back-compatibility)
-- uses 3d if 3d is available, 2d otherwise
CREATE OR REPLACE FUNCTION length3d_spheroid(geometry, spheroid)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_length_ellipsoid_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION length_spheroid(geometry, spheroid)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_length_ellipsoid_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION length2d_spheroid(geometry, spheroid)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_length2d_ellipsoid_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-- this is a fake (for back-compatibility)
-- uses 3d if 3d is available, 2d otherwise
CREATE OR REPLACE FUNCTION perimeter3d(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_perimeter_poly'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION perimeter2d(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_perimeter2d_poly'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION perimeter(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_perimeter_poly'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-- this is an alias for 'area(geometry)'
-- there is nothing such an 'area3d'...
CREATE OR REPLACE FUNCTION area2d(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_area_polygon'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION area(geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_area_polygon'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION distance_spheroid(geometry,geometry,spheroid)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_distance_ellipsoid_point'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION distance_sphere(geometry,geometry)
	RETURNS FLOAT8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_distance_sphere'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-- Minimum distance. 2d only.
CREATE OR REPLACE FUNCTION distance(geometry,geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_mindistance2d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- Maximum distance between linestrings. 2d only. Very bogus.
CREATE OR REPLACE FUNCTION max_distance(geometry,geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_maxdistance2d_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION point_inside_circle(geometry,float8,float8,float8)
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_inside_circle_point'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION azimuth(geometry,geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_azimuth'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);


------------------------------------------------------------------------
-- MISC
------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION force_2d(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_2d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION force_3dz(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_3dz'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-- an alias for force_3dz
CREATE OR REPLACE FUNCTION force_3d(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_3dz'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION force_3dm(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_3dm'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION force_4d(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_4d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION force_collection(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_collection'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION multi(geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_force_multi'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION collector(geometry, geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_collect'
	LANGUAGE 'C' IMMUTABLE;

CREATE OR REPLACE FUNCTION collect(geometry, geometry) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_collect'
	LANGUAGE 'C' IMMUTABLE;

CREATE AGGREGATE memcollect(
	sfunc = collect,
	basetype = geometry,
	stype = geometry
	);

CREATE OR REPLACE FUNCTION geom_accum (geometry[],geometry)
	RETURNS geometry[]
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_accum'
	LANGUAGE 'C' IMMUTABLE;

CREATE AGGREGATE accum (
	sfunc = geom_accum,
	basetype = geometry,
	stype = geometry[]
	);

CREATE OR REPLACE FUNCTION collect_garray (geometry[])
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_collect_garray'
	LANGUAGE 'C' IMMUTABLE STRICT;

CREATE AGGREGATE collect (
	sfunc = geom_accum,
	basetype = geometry,
	stype = geometry[],
	finalfunc = collect_garray
	);

CREATE OR REPLACE FUNCTION expand(box3d,float8)
	RETURNS box3d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX3D_expand'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION expand(box2d,float8)
	RETURNS box2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2DFLOAT4_expand'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION expand(geometry,float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_expand'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION envelope(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_envelope'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION reverse(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_reverse'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION ForceRHR(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_forceRHR_poly'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION noop(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_noop'
	LANGUAGE 'C' VOLATILE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION zmflag(geometry)
	RETURNS smallint
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_zmflag'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION hasBBOX(geometry)
	RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_hasBBOX'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION ndims(geometry)
	RETURNS smallint
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_ndims'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION AsEWKT(geometry)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asEWKT'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsEWKB(geometry)
	RETURNS BYTEA
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','WKBFromLWGEOM'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsHEXEWKB(geometry)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asHEXEWKB'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsHEXEWKB(geometry, text)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asHEXEWKB'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsEWKB(geometry,text)
	RETURNS bytea
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','WKBFromLWGEOM'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomFromEWKB(bytea)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOMFromWKB'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomFromEWKT(text)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','parse_WKT_lwgeom'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION cache_bbox()
	RETURNS trigger
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C';

------------------------------------------------------------------------
-- CONSTRUCTORS
------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION makePoint(float8, float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makepoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION makePoint(float8, float8, float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makepoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION makePoint(float8, float8, float8, float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makepoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION makePointM(float8, float8, float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makepoint3dm'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION makeBox2d(geometry, geometry)
	RETURNS box2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2DFLOAT4_construct'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION makeBox3d(geometry, geometry)
	RETURNS box3d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX3D_construct'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION makeline_garray (geometry[])
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makeline_garray'
	LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION LineFromMultiPoint(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_line_from_mpoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION MakeLine(geometry, geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makeline'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION AddPoint(geometry, geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_addpoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION AddPoint(geometry, geometry, integer)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_addpoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION RemovePoint(geometry, integer)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_removepoint'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION SetPoint(geometry, integer, geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_setpoint_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE AGGREGATE makeline (
	sfunc = geom_accum,
	basetype = geometry,
	stype = geometry[],
	finalfunc = makeline_garray
	);

CREATE OR REPLACE FUNCTION MakePolygon(geometry, geometry[])
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makepoly'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION MakePolygon(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_makepoly'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION BuildArea(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_buildarea'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);

CREATE OR REPLACE FUNCTION polygonize_garray (geometry[])
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'polygonize_garray'
	LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION LineMerge(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'linemerge'
	LANGUAGE 'C' IMMUTABLE STRICT;

CREATE AGGREGATE polygonize (
	sfunc = geom_accum,
	basetype = geometry,
	stype = geometry[],
	finalfunc = polygonize_garray
	);



CREATE TYPE geometry_dump AS (path integer[], geom geometry);

CREATE OR REPLACE FUNCTION Dump(geometry)
	RETURNS SETOF geometry_dump
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_dump'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION DumpRings(geometry)
	RETURNS SETOF geometry_dump
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_dump_rings'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);


------------------------------------------------------------------------

--
-- Aggregate functions
--

CREATE OR REPLACE FUNCTION combine_bbox(box2d,geometry)
	RETURNS box2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX2DFLOAT4_combine'
	LANGUAGE 'C' IMMUTABLE;

CREATE AGGREGATE extent(
	sfunc = combine_bbox,
	basetype = geometry,
	stype = box2d
	);

CREATE OR REPLACE FUNCTION combine_bbox(box3d,geometry)
	RETURNS box3d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'BOX3D_combine'
	LANGUAGE 'C' IMMUTABLE;

CREATE AGGREGATE extent3d(
	sfunc = combine_bbox,
	basetype = geometry,
	stype = box3d
	);

-----------------------------------------------------------------------
-- CREATE_HISTOGRAM2D( <box2d>, <size> )
-----------------------------------------------------------------------
--
-- Returns a histgram with 0s in all the boxes.
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_histogram2d(box2d,int)
	RETURNS histogram2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','create_lwhistogram2d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- BUILD_HISTOGRAM2D( <histogram2d>, <tablename>, <columnname> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION build_histogram2d (histogram2d,text,text)
	RETURNS histogram2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','build_lwhistogram2d'
	LANGUAGE 'C' STABLE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- BUILD_HISTOGRAM2D(<histogram2d>,<schema>,<tablename>,<columnname>)
-----------------------------------------------------------------------
-- This is a wrapper to the omonimous schema unaware function,
-- thanks to Carl Anderson for the idea.
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION build_histogram2d (histogram2d,text,text,text)
RETURNS histogram2d
AS '
BEGIN
	EXECUTE ''SET local search_path = ''||$2||'',public'';
	RETURN public.build_histogram2d($1,$3,$4);
END
'
LANGUAGE 'plpgsql' STABLE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- EXPLODE_HISTOGRAM2D( <histogram2d>, <tablename> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION explode_histogram2d (histogram2d,text)
	RETURNS histogram2d
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','explode_lwhistogram2d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- ESTIMATE_HISTOGRAM2D( <histogram2d>, <box> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION estimate_histogram2d(histogram2d,box2d)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','estimate_lwhistogram2d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- ESTIMATED_EXTENT( <schema name>, <table name>, <column name> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION estimated_extent(text,text,text) RETURNS box2d AS
	'/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_estimated_extent'
	LANGUAGE 'C' IMMUTABLE STRICT SECURITY DEFINER;

-----------------------------------------------------------------------
-- ESTIMATED_EXTENT( <table name>, <column name> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION estimated_extent(text,text) RETURNS box2d AS
	'/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_estimated_extent'
	LANGUAGE 'C' IMMUTABLE STRICT SECURITY DEFINER; 

-----------------------------------------------------------------------
-- FIND_EXTENT( <schema name>, <table name>, <column name> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION find_extent(text,text,text) RETURNS box2d AS
'
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE ''SELECT extent("''||columnname||''") FROM "''||schemaname||''"."''||tablename||''"'' LOOP
		return myrec.extent;
	END LOOP; 
END;
'
LANGUAGE 'plpgsql' IMMUTABLE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- FIND_EXTENT( <table name>, <column name> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION find_extent(text,text) RETURNS box2d AS
'
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE ''SELECT extent("''||columnname||''") FROM "''||tablename||''"'' LOOP
		return myrec.extent;
	END LOOP; 
END;
'
LANGUAGE 'plpgsql' IMMUTABLE STRICT; -- WITH (isstrict);

-------------------------------------------------------------------
-- SPATIAL_REF_SYS
-------------------------------------------------------------------
CREATE TABLE spatial_ref_sys (
	 srid integer not null primary key,
	 auth_name varchar(256), 
	 auth_srid integer, 
	 srtext varchar(2048),
	 proj4text varchar(2048) 
);

-------------------------------------------------------------------
-- GEOMETRY_COLUMNS
-------------------------------------------------------------------
CREATE TABLE geometry_columns (
	f_table_catalog varchar(256) not null,
	f_table_schema varchar(256) not null,
	f_table_name varchar(256) not null,
	f_geometry_column varchar(256) not null,
	coord_dimension integer not null,
	srid integer not null,
	type varchar(30) not null,
	CONSTRAINT geometry_columns_pk primary key ( 
		f_table_catalog, 
		f_table_schema, 
		f_table_name, 
		f_geometry_column )
) WITH OIDS;

-----------------------------------------------------------------------
-- RENAME_GEOMETRY_TABLE_CONSTRAINTS()
-----------------------------------------------------------------------
-- This function has been obsoleted for the difficulty in
-- finding attribute on which the constraint is applied.
-- AddGeometryColumn will name the constraints in a meaningful
-- way, but nobody can rely on it since old postgis versions did
-- not do that.
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION rename_geometry_table_constraints() RETURNS text
AS 
'
SELECT ''rename_geometry_table_constraint() is obsoleted''::text
'
LANGUAGE 'SQL' IMMUTABLE;

-----------------------------------------------------------------------
-- FIX_GEOMETRY_COLUMNS() 
-----------------------------------------------------------------------
-- This function will:
--
--	o try to fix the schema of records with an invalid one
--		(for PG>=73)
--
--	o link records to system tables through attrelid and varattnum
--		(for PG<75)
--
--	o delete all records for which no linking was possible
--		(for PG<75)
--	
-- 
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fix_geometry_columns() RETURNS text
AS 
'
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to 
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	UPDATE geometry_columns SET f_table_schema = n.nspname
		FROM pg_namespace n, pg_class c, pg_attribute a,
			pg_constraint sridcheck, pg_constraint typecheck
                WHERE ( f_table_schema is NULL
		OR f_table_schema = ''''
                OR f_table_schema NOT IN (
                        SELECT nspname::varchar
                        FROM pg_namespace nn, pg_class cc, pg_attribute aa
                        WHERE cc.relnamespace = nn.oid
                        AND cc.relname = f_table_name::name
                        AND aa.attrelid = cc.oid
                        AND aa.attname = f_geometry_column::name))
                AND f_table_name::name = c.relname
                AND c.oid = a.attrelid
                AND c.relnamespace = n.oid
                AND f_geometry_column::name = a.attname

                AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE ''(srid(% = %)''
                AND sridcheck.consrc ~ textcat('' = '', srid::text)

                AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
	''((geometrytype(%) = ''''%''''::text) OR (% IS NULL))''
                AND typecheck.consrc ~ textcat('' = '''''', type::text)

                AND NOT EXISTS (
                        SELECT oid FROM geometry_columns gc
                        WHERE c.relname::varchar = gc.f_table_name
                        AND n.nspname::varchar = gc.f_table_schema
                        AND a.attname::varchar = gc.f_geometry_column
                );

	GET DIAGNOSTICS foundschema = ROW_COUNT;

	-- no linkage to system table needed
	return ''fixed:''||foundschema::text;

	-- fix linking to system tables
	SELECT 0 INTO linked;
	FOR mislinked in
		SELECT gc.oid as gcrec,
			a.attrelid as attrelid, a.attnum as attnum
                FROM geometry_columns gc, pg_class c,
		pg_namespace n, pg_attribute a
                WHERE ( gc.attrelid IS NULL OR gc.attrelid != a.attrelid 
			OR gc.varattnum IS NULL OR gc.varattnum != a.attnum)
                AND n.nspname = gc.f_table_schema::name
                AND c.relnamespace = n.oid
                AND c.relname = gc.f_table_name::name
                AND a.attname = f_geometry_column::name
                AND a.attrelid = c.oid
	LOOP
		UPDATE geometry_columns SET
			attrelid = mislinked.attrelid,
			varattnum = mislinked.attnum,
			stats = NULL
			WHERE geometry_columns.oid = mislinked.gcrec;
		SELECT linked+1 INTO linked;
	END LOOP; 

	-- remove stale records
	DELETE FROM geometry_columns WHERE attrelid IS NULL;

	GET DIAGNOSTICS deleted = ROW_COUNT;

	result = 
		''fixed:'' || foundschema::text ||
		'' linked:'' || linked::text || 
		'' deleted:'' || deleted::text;

	return result;

END;
'
LANGUAGE 'plpgsql' VOLATILE;

-----------------------------------------------------------------------
-- PROBE_GEOMETRY_COLUMNS() 
-----------------------------------------------------------------------
-- Fill the geometry_columns table with values probed from the system
-- catalogues. 3d flag cannot be probed, it defaults to 2
--
-- Note that bogus records already in geometry_columns are not
-- overridden (a check for schema.table.column is performed), so
-- to have a fresh probe backup your geometry_column, delete from
-- it and probe.
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION probe_geometry_columns() RETURNS text AS
'
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN

	SELECT count(*) INTO oldcount FROM geometry_columns;

	SELECT count(*) INTO probed
		FROM pg_class c, pg_attribute a, pg_type t, 
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck

		WHERE t.typname = ''geometry''
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid

		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE ''(srid(''||a.attname||'') = %)''
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
	''((geometrytype(''||a.attname||'') = ''''%''''::text) OR (% IS NULL))''
		;

	INSERT INTO geometry_columns SELECT
		''''::varchar as f_table_catalogue,
		n.nspname::varchar as f_table_schema,
		c.relname::varchar as f_table_name,
		a.attname::varchar as f_geometry_column,
		2 as coord_dimension,
		trim(both  '' =)'' from substr(sridcheck.consrc,
			strpos(sridcheck.consrc, ''='')))::integer as srid,
		trim(both '' =)'''''' from substr(typecheck.consrc, 
			strpos(typecheck.consrc, ''=''),
			strpos(typecheck.consrc, ''::'')-
			strpos(typecheck.consrc, ''='')
			))::varchar as type

		FROM pg_class c, pg_attribute a, pg_type t, 
			pg_namespace n,
			pg_constraint sridcheck, pg_constraint typecheck
		WHERE t.typname = ''geometry''
		AND a.atttypid = t.oid
		AND a.attrelid = c.oid
		AND c.relnamespace = n.oid
		AND sridcheck.connamespace = n.oid
		AND typecheck.connamespace = n.oid
		AND sridcheck.conrelid = c.oid
		AND sridcheck.consrc LIKE ''(srid(''||a.attname||'') = %)''
		AND typecheck.conrelid = c.oid
		AND typecheck.consrc LIKE
	''((geometrytype(''||a.attname||'') = ''''%''''::text) OR (% IS NULL))''

                AND NOT EXISTS (
                        SELECT oid FROM geometry_columns gc
                        WHERE c.relname::varchar = gc.f_table_name
                        AND n.nspname::varchar = gc.f_table_schema
                        AND a.attname::varchar = gc.f_geometry_column
                );

	GET DIAGNOSTICS inserted = ROW_COUNT;

	IF oldcount > probed THEN
		stale = oldcount-probed;
	ELSE
		stale = 0;
	END IF;

        RETURN ''probed:''||probed||
		'' inserted:''||inserted||
		'' conflicts:''||probed-inserted||
		'' stale:''||stale;
END

'
LANGUAGE 'plpgsql' VOLATILE;

-----------------------------------------------------------------------
-- ADDGEOMETRYCOLUMN
--   <catalogue>, <schema>, <table>, <column>, <srid>, <type>, <dim>
-----------------------------------------------------------------------
--
-- Type can be one of geometry, GEOMETRYCOLLECTION, POINT, MULTIPOINT, POLYGON,
-- MULTIPOLYGON, LINESTRING, or MULTILINESTRING.
--
-- Types (except geometry) are checked for consistency using a CHECK constraint
-- uses SQL ALTER TABLE command to add the geometry column to the table.
-- Addes a row to geometry_columns.
-- Addes a constraint on the table that all the geometries MUST have the same 
-- SRID. Checks the coord_dimension to make sure its between 0 and 3.
-- Should also check the precision grid (future expansion).
-- Calls fix_geometry_columns() at the end.
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AddGeometryColumn(varchar,varchar,varchar,varchar,integer,varchar,integer)
	RETURNS text
	AS 
'
DECLARE
	catalog_name alias for $1;
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	new_type alias for $6;
	new_dim alias for $7;
	rec RECORD;
	schema_ok bool;
	real_schema name;

BEGIN

	IF ( not ( (new_type =''GEOMETRY'') or
		   (new_type =''GEOMETRYCOLLECTION'') or
		   (new_type =''POINT'') or 
		   (new_type =''MULTIPOINT'') or
		   (new_type =''POLYGON'') or
		   (new_type =''MULTIPOLYGON'') or
		   (new_type =''LINESTRING'') or
		   (new_type =''MULTILINESTRING'') or
		   (new_type =''GEOMETRYCOLLECTIONM'') or
		   (new_type =''POINTM'') or 
		   (new_type =''MULTIPOINTM'') or
		   (new_type =''POLYGONM'') or
		   (new_type =''MULTIPOLYGONM'') or
		   (new_type =''LINESTRINGM'') or
		   (new_type =''MULTILINESTRINGM'')) )
	THEN
		RAISE EXCEPTION ''Invalid type name - valid ones are: 
			GEOMETRY, GEOMETRYCOLLECTION, POINT, 
			MULTIPOINT, POLYGON, MULTIPOLYGON, 
			LINESTRING, MULTILINESTRING,
			GEOMETRYCOLLECTIONM, POINTM, 
			MULTIPOINTM, POLYGONM, MULTIPOLYGONM, 
			LINESTRINGM, or MULTILINESTRINGM '';
		return ''fail'';
	END IF;

	IF ( (new_dim >4) or (new_dim <0) ) THEN
		RAISE EXCEPTION ''invalid dimension'';
		return ''fail'';
	END IF;

	IF ( (new_type LIKE ''%M'') and (new_dim!=3) ) THEN

		RAISE EXCEPTION ''TypeM needs 3 dimensions'';
		return ''fail'';
	END IF;

	IF ( schema_name != '''' ) THEN
		schema_ok = ''f'';
		FOR rec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			schema_ok := ''t'';
		END LOOP;

		if ( schema_ok <> ''t'' ) THEN
			RAISE NOTICE ''Invalid schema name - using current_schema()'';
			SELECT current_schema() into real_schema;
		ELSE
			real_schema = schema_name;
		END IF;

	ELSE
		SELECT current_schema() into real_schema;
	END IF;


	-- Add geometry column

	EXECUTE ''ALTER TABLE '' ||
		quote_ident(real_schema) || ''.'' || quote_ident(table_name)
		|| '' ADD COLUMN '' || quote_ident(column_name) || 
		'' geometry '';


	-- Delete stale record in geometry_column (if any)

	EXECUTE ''DELETE FROM geometry_columns WHERE
		f_table_catalog = '' || quote_literal('''') || 
		'' AND f_table_schema = '' ||
		quote_literal(real_schema) || 
		'' AND f_table_name = '' || quote_literal(table_name) ||
		'' AND f_geometry_column = '' || quote_literal(column_name);


	-- Add record in geometry_column 

	EXECUTE ''INSERT INTO geometry_columns VALUES ('' ||
		quote_literal('''') || '','' ||
		quote_literal(real_schema) || '','' ||
		quote_literal(table_name) || '','' ||
		quote_literal(column_name) || '','' ||
		new_dim || '','' || new_srid || '','' ||
		quote_literal(new_type) || '')'';

	-- Add table checks

	EXECUTE ''ALTER TABLE '' || 
		quote_ident(real_schema) || ''.'' || quote_ident(table_name)
		|| '' ADD CONSTRAINT '' 
		|| quote_ident(''enforce_srid_'' || column_name)
		|| '' CHECK (SRID('' || quote_ident(column_name) ||
		'') = '' || new_srid || '')'' ;

	EXECUTE ''ALTER TABLE '' || 
		quote_ident(real_schema) || ''.'' || quote_ident(table_name)
		|| '' ADD CONSTRAINT ''
		|| quote_ident(''enforce_dims_'' || column_name)
		|| '' CHECK (ndims('' || quote_ident(column_name) ||
		'') = '' || new_dim || '')'' ;

	IF (not(new_type = ''GEOMETRY'')) THEN
		EXECUTE ''ALTER TABLE '' || 
		quote_ident(real_schema) || ''.'' || quote_ident(table_name)
		|| '' ADD CONSTRAINT ''
		|| quote_ident(''enforce_geotype_'' || column_name)
		|| '' CHECK (geometrytype('' ||
		quote_ident(column_name) || '')='' ||
		quote_literal(new_type) || '' OR ('' ||
		quote_ident(column_name) || '') is null)'';
	END IF;

	return 
		real_schema || ''.'' || 
		table_name || ''.'' || column_name ||
		'' SRID:'' || new_srid ||
		'' TYPE:'' || new_type || 
		'' DIMS:'' || new_dim || chr(10) || '' ''; 
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

----------------------------------------------------------------------------
-- ADDGEOMETRYCOLUMN ( <schema>, <table>, <column>, <srid>, <type>, <dim> )
----------------------------------------------------------------------------
--
-- This is a wrapper to the real AddGeometryColumn, for use
-- when catalogue is undefined
--
----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AddGeometryColumn(varchar,varchar,varchar,integer,varchar,integer) RETURNS text AS '
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('''',$1,$2,$3,$4,$5,$6) into ret;
	RETURN ret;
END;
'
LANGUAGE 'plpgsql' STABLE STRICT; -- WITH (isstrict);

----------------------------------------------------------------------------
-- ADDGEOMETRYCOLUMN ( <table>, <column>, <srid>, <type>, <dim> )
----------------------------------------------------------------------------
--
-- This is a wrapper to the real AddGeometryColumn, for use
-- when catalogue and schema are undefined
--
----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AddGeometryColumn(varchar,varchar,integer,varchar,integer) RETURNS text AS '
DECLARE
	ret  text;
BEGIN
	SELECT AddGeometryColumn('''','''',$1,$2,$3,$4,$5) into ret;
	RETURN ret;
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- DROPGEOMETRYCOLUMN
--   <catalogue>, <schema>, <table>, <column>
-----------------------------------------------------------------------
--
-- Removes geometry column reference from geometry_columns table.
-- Drops the column with pgsql >= 73.
-- Make some silly enforcements on it for pgsql < 73
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DropGeometryColumn(varchar, varchar,varchar,varchar)
	RETURNS text
	AS 
'
DECLARE
	catalog_name alias for $1; 
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	myrec RECORD;
	okay boolean;
	real_schema name;

BEGIN


	-- Find, check or fix schema_name
	IF ( schema_name != '''' ) THEN
		okay = ''f'';

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := ''t'';
		END LOOP;

		IF ( okay <> ''t'' ) THEN
			RAISE NOTICE ''Invalid schema name - using current_schema()'';
			SELECT current_schema() into real_schema;
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT current_schema() into real_schema;
	END IF;

 	-- Find out if the column is in the geometry_columns table
	okay = ''f'';
	FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := ''t'';
	END LOOP; 
	IF (okay <> ''t'') THEN 
		RAISE EXCEPTION ''column not found in geometry_columns table'';
		RETURN ''f'';
	END IF;

	-- Remove ref from geometry_columns table
	EXECUTE ''delete from geometry_columns where f_table_schema = '' ||
		quote_literal(real_schema) || '' and f_table_name = '' ||
		quote_literal(table_name)  || '' and f_geometry_column = '' ||
		quote_literal(column_name);
	
	-- Remove table column
	EXECUTE ''ALTER TABLE '' || quote_ident(real_schema) || ''.'' ||
		quote_ident(table_name) || '' DROP COLUMN '' ||
		quote_ident(column_name);


	RETURN real_schema || ''.'' || table_name || ''.'' || column_name ||'' effectively removed.'';
	
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- DROPGEOMETRYCOLUMN
--   <schema>, <table>, <column>
-----------------------------------------------------------------------
--
-- This is a wrapper to the real DropGeometryColumn, for use
-- when catalogue is undefined
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DropGeometryColumn(varchar,varchar,varchar)
	RETURNS text
	AS 
'
DECLARE
	ret text;
BEGIN
	SELECT DropGeometryColumn('''',$1,$2,$3) into ret;
	RETURN ret;
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- DROPGEOMETRYCOLUMN
--   <table>, <column>
-----------------------------------------------------------------------
--
-- This is a wrapper to the real DropGeometryColumn, for use
-- when catalogue and schema is undefined. 
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DropGeometryColumn(varchar,varchar)
	RETURNS text
	AS 
'
DECLARE
	ret text;
BEGIN
	SELECT DropGeometryColumn('''','''',$1,$2) into ret;
	RETURN ret;
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- DROPGEOMETRYTABLE
--   <catalogue>, <schema>, <table>
-----------------------------------------------------------------------
--
-- Drop a table and all its references in geometry_columns
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DropGeometryTable(varchar, varchar,varchar)
	RETURNS text
	AS 
'
DECLARE
	catalog_name alias for $1; 
	schema_name alias for $2;
	table_name alias for $3;
	real_schema name;

BEGIN

	IF ( schema_name = '''' ) THEN
		SELECT current_schema() into real_schema;
	ELSE
		real_schema = schema_name;
	END IF;

	-- Remove refs from geometry_columns table
	EXECUTE ''DELETE FROM geometry_columns WHERE '' ||
		''f_table_schema = '' || quote_literal(real_schema) ||
		'' AND '' ||
		'' f_table_name = '' || quote_literal(table_name);
	
	-- Remove table 
	EXECUTE ''DROP TABLE ''
		|| quote_ident(real_schema) || ''.'' ||
		quote_ident(table_name);

	RETURN
		real_schema || ''.'' ||
		table_name ||'' dropped.'';
	
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- DROPGEOMETRYTABLE
--   <schema>, <table>
-----------------------------------------------------------------------
--
-- Drop a table and all its references in geometry_columns
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DropGeometryTable(varchar,varchar) RETURNS text AS 
'SELECT DropGeometryTable('''',$1,$2)'
LANGUAGE 'sql' WITH (isstrict);

-----------------------------------------------------------------------
-- DROPGEOMETRYTABLE
--   <table>
-----------------------------------------------------------------------
--
-- Drop a table and all its references in geometry_columns
-- For PG>=73 use current_schema()
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION DropGeometryTable(varchar) RETURNS text AS 
'SELECT DropGeometryTable('''','''',$1)'
LANGUAGE 'sql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- UPDATEGEOMETRYSRID
--   <catalogue>, <schema>, <table>, <column>, <srid>
-----------------------------------------------------------------------
--
-- Change SRID of all features in a spatially-enabled table
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION UpdateGeometrySRID(varchar,varchar,varchar,varchar,integer)
	RETURNS text
	AS 
'
DECLARE
	catalog_name alias for $1; 
	schema_name alias for $2;
	table_name alias for $3;
	column_name alias for $4;
	new_srid alias for $5;
	myrec RECORD;
	okay boolean;
	cname varchar;
	real_schema name;

BEGIN


	-- Find, check or fix schema_name
	IF ( schema_name != '''' ) THEN
		okay = ''f'';

		FOR myrec IN SELECT nspname FROM pg_namespace WHERE text(nspname) = schema_name LOOP
			okay := ''t'';
		END LOOP;

		IF ( okay <> ''t'' ) THEN
			RAISE EXCEPTION ''Invalid schema name'';
		ELSE
			real_schema = schema_name;
		END IF;
	ELSE
		SELECT INTO real_schema current_schema()::text;
	END IF;

 	-- Find out if the column is in the geometry_columns table
	okay = ''f'';
	FOR myrec IN SELECT * from geometry_columns where f_table_schema = text(real_schema) and f_table_name = table_name and f_geometry_column = column_name LOOP
		okay := ''t'';
	END LOOP; 
	IF (okay <> ''t'') THEN 
		RAISE EXCEPTION ''column not found in geometry_columns table'';
		RETURN ''f'';
	END IF;

	-- Update ref from geometry_columns table
	EXECUTE ''UPDATE geometry_columns SET SRID = '' || new_srid || 
		'' where f_table_schema = '' ||
		quote_literal(real_schema) || '' and f_table_name = '' ||
		quote_literal(table_name)  || '' and f_geometry_column = '' ||
		quote_literal(column_name);
	
	-- Make up constraint name
	cname = ''enforce_srid_''  || column_name;

	-- Drop enforce_srid constraint
	EXECUTE ''ALTER TABLE '' || quote_ident(real_schema) ||
		''.'' || quote_ident(table_name) ||
		'' DROP constraint '' || quote_ident(cname);

	-- Update geometries SRID
	EXECUTE ''UPDATE '' || quote_ident(real_schema) ||
		''.'' || quote_ident(table_name) ||
		'' SET '' || quote_ident(column_name) ||
		'' = setSRID('' || quote_ident(column_name) ||
		'', '' || new_srid || '')'';

	-- Reset enforce_srid constraint
	EXECUTE ''ALTER TABLE '' || quote_ident(real_schema) ||
		''.'' || quote_ident(table_name) ||
		'' ADD constraint '' || quote_ident(cname) ||
		'' CHECK (srid('' || quote_ident(column_name) ||
		'') = '' || new_srid || '')'';

	RETURN real_schema || ''.'' || table_name || ''.'' || column_name ||'' SRID changed to '' || new_srid;
	
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- UPDATEGEOMETRYSRID
--   <schema>, <table>, <column>, <srid>
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION UpdateGeometrySRID(varchar,varchar,varchar,integer)
	RETURNS text
	AS '
DECLARE
	ret  text;
BEGIN
	SELECT UpdateGeometrySRID('''',$1,$2,$3,$4) into ret;
	RETURN ret;
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- UPDATEGEOMETRYSRID
--   <table>, <column>, <srid>
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION UpdateGeometrySRID(varchar,varchar,integer)
	RETURNS text
	AS '
DECLARE
	ret  text;
BEGIN
	SELECT UpdateGeometrySRID('''','''',$1,$2,$3) into ret;
	RETURN ret;
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT; -- WITH (isstrict);

-----------------------------------------------------------------------
-- UPDATE_GEOMETRY_STATS()
-----------------------------------------------------------------------
--
-- Only meaningful for PG<75.
-- Gather statisticts about geometry columns for use
-- with cost estimator.
--
-- It is defined also for PG>=75 for back-compatibility
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_geometry_stats() RETURNS text
AS ' SELECT ''update_geometry_stats() has been obsoleted. Statistics are automatically built running the ANALYZE command''::text' LANGUAGE 'sql';

-----------------------------------------------------------------------
-- UPDATE_GEOMETRY_STATS( <table>, <column> )
-----------------------------------------------------------------------
--
-- Only meaningful for PG<75.
-- Gather statisticts about a geometry column for use
-- with cost estimator.
--
-- It is defined also for PG>=75 for back-compatibility
--
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_geometry_stats(varchar,varchar) RETURNS text
AS 'SELECT update_geometry_stats();' LANGUAGE 'sql' ;

-----------------------------------------------------------------------
-- FIND_SRID( <schema>, <table>, <geom col> )
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION find_srid(varchar,varchar,varchar) RETURNS int4 AS
'DECLARE
   schem text;
   tabl text;
   sr int4;
BEGIN
   IF $1 IS NULL THEN
      RAISE EXCEPTION ''find_srid() - schema is NULL!'';
   END IF;
   IF $2 IS NULL THEN
      RAISE EXCEPTION ''find_srid() - table name is NULL!'';
   END IF;
   IF $3 IS NULL THEN
      RAISE EXCEPTION ''find_srid() - column name is NULL!'';
   END IF;
   schem = $1;
   tabl = $2;
-- if the table contains a . and the schema is empty
-- split the table into a schema and a table
-- otherwise drop through to default behavior
   IF ( schem = '''' and tabl LIKE ''%.%'' ) THEN
     schem = substr(tabl,1,strpos(tabl,''.'')-1);
     tabl = substr(tabl,length(schem)+2);
   ELSE
     schem = schem || ''%'';
   END IF;

   select SRID into sr from geometry_columns where f_table_schema like schem and f_table_name = tabl and f_geometry_column = $3;
   IF NOT FOUND THEN
       RAISE EXCEPTION ''find_srid() - couldnt find the corresponding SRID - is the geometry registered in the GEOMETRY_COLUMNS table?  Is there an uppercase/lowercase missmatch?'';
   END IF;
  return sr;
END;
'
LANGUAGE 'plpgsql' IMMUTABLE STRICT; -- WITH (iscachable); 


---------------------------------------------------------------
-- PROJ support
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_proj4_from_srid(integer) RETURNS text AS
'
BEGIN
	RETURN proj4text::text FROM spatial_ref_sys WHERE srid= $1;
END;
'
LANGUAGE 'plpgsql' IMMUTABLE STRICT; -- WITH (iscachable,isstrict);



CREATE OR REPLACE FUNCTION transform_geometry(geometry,text,text,int)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','transform_geom'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION transform(geometry,integer)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','transform'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);


-----------------------------------------------------------------------
-- POSTGIS_VERSION()
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION postgis_version() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_proj_version() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;

--
-- IMPORTANT:
-- Starting at 1.1.0 this function is used by postgis_proc_upgrade.pl
-- to extract version of postgis being installed.
-- Do not modify this w/out also changing postgis_proc_upgrade.pl
--
CREATE OR REPLACE FUNCTION postgis_scripts_installed() RETURNS text
        AS 'SELECT ''1.1.4''::text AS version'
        LANGUAGE 'sql' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_lib_version() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE; -- a new lib will require a new session

-- NOTE: starting at 1.1.0 this is the same of postgis_lib_version()
CREATE OR REPLACE FUNCTION postgis_scripts_released() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_uses_stats() RETURNS bool
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_geos_version() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_jts_version() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_scripts_build_date() RETURNS text
        AS 'SELECT ''2006-10-04 15:11:07''::text AS version'
        LANGUAGE 'sql' IMMUTABLE;

CREATE OR REPLACE FUNCTION postgis_lib_build_date() RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE;



CREATE OR REPLACE FUNCTION postgis_full_version() RETURNS text
AS '
DECLARE
	libver text;
	projver text;
	geosver text;
	jtsver text;
	usestats bool;
	dbproc text;
	relproc text;
	fullver text;
BEGIN
	SELECT postgis_lib_version() INTO libver;
	SELECT postgis_proj_version() INTO projver;
	SELECT postgis_geos_version() INTO geosver;
	SELECT postgis_jts_version() INTO jtsver;
	SELECT postgis_uses_stats() INTO usestats;
	SELECT postgis_scripts_installed() INTO dbproc;
	SELECT postgis_scripts_released() INTO relproc;

	fullver = ''POSTGIS="'' || libver || ''"'';

	IF  geosver IS NOT NULL THEN
		fullver = fullver || '' GEOS="'' || geosver || ''"'';
	END IF;

	IF  jtsver IS NOT NULL THEN
		fullver = fullver || '' JTS="'' || jtsver || ''"'';
	END IF;

	IF  projver IS NOT NULL THEN
		fullver = fullver || '' PROJ="'' || projver || ''"'';
	END IF;

	IF usestats THEN
		fullver = fullver || '' USE_STATS'';
	END IF;

	-- fullver = fullver || '' DBPROC="'' || dbproc || ''"'';
	-- fullver = fullver || '' RELPROC="'' || relproc || ''"'';

	IF dbproc != relproc THEN
		fullver = fullver || '' (procs from '' || dbproc || '' need upgrade)'';
	END IF;

	RETURN fullver;
END
'
LANGUAGE 'plpgsql' IMMUTABLE;

---------------------------------------------------------------
-- CASTS
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION box2d(geometry)
        RETURNS box2d
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_to_BOX2DFLOAT4'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box3d(geometry)
        RETURNS box3d
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_to_BOX3D'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box(geometry)
        RETURNS box
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_to_BOX'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box2d(box3d)
        RETURNS box2d
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_to_BOX2DFLOAT4'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box3d(box2d)
        RETURNS box3d
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX2DFLOAT4_to_BOX3D'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION box(box3d)
        RETURNS box
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_to_BOX'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION text(geometry)
        RETURNS text
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_to_text'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- this is kept for backward-compatibility
CREATE OR REPLACE FUNCTION box3dtobox(box3d)
        RETURNS box
        AS 'SELECT box($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry(box2d)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX2DFLOAT4_to_LWGEOM'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry(box3d)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOX3D_to_LWGEOM'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry(text)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','parse_WKT_lwgeom'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry(chip)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','CHIP_to_LWGEOM'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION geometry(bytea)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_from_bytea'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION bytea(geometry)
	RETURNS bytea
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_to_bytea'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION text(bool)
	RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','BOOL_to_text'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- 7.3+ explicit casting definitions
CREATE CAST (geometry AS box2d) WITH FUNCTION box2d(geometry) AS IMPLICIT;
CREATE CAST (geometry AS box3d) WITH FUNCTION box3d(geometry) AS IMPLICIT;
CREATE CAST (geometry AS box) WITH FUNCTION box(geometry) AS IMPLICIT;
CREATE CAST (box3d AS box2d) WITH FUNCTION box2d(box3d) AS IMPLICIT;
CREATE CAST (box2d AS box3d) WITH FUNCTION box3d(box2d) AS IMPLICIT;
CREATE CAST (box2d AS geometry) WITH FUNCTION geometry(box2d) AS IMPLICIT;
CREATE CAST (box3d AS box) WITH FUNCTION box(box3d) AS IMPLICIT;
CREATE CAST (box3d AS geometry) WITH FUNCTION geometry(box3d) AS IMPLICIT;
CREATE CAST (text AS geometry) WITH FUNCTION geometry(text) AS IMPLICIT;
CREATE CAST (geometry AS text) WITH FUNCTION text(geometry) AS IMPLICIT;
CREATE CAST (chip AS geometry) WITH FUNCTION geometry(chip) AS IMPLICIT;
CREATE CAST (bytea AS geometry) WITH FUNCTION geometry(bytea) AS IMPLICIT;
CREATE CAST (geometry AS bytea) WITH FUNCTION bytea(geometry) AS IMPLICIT;
CREATE CAST (bool AS text) WITH FUNCTION text(bool) AS IMPLICIT;

---------------------------------------------------------------
-- Algorithms
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION simplify(geometry, float8)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_simplify2d'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- SnapToGrid(input, xoff, yoff, xsize, ysize)
CREATE OR REPLACE FUNCTION SnapToGrid(geometry, float8, float8, float8, float8)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_snaptogrid'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- SnapToGrid(input, xsize, ysize) # offsets=0
CREATE OR REPLACE FUNCTION SnapToGrid(geometry, float8, float8)
   RETURNS geometry
   AS 'SELECT SnapToGrid($1, 0, 0, $2, $3)'
   LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- SnapToGrid(input, size) # xsize=ysize=size, offsets=0
CREATE OR REPLACE FUNCTION SnapToGrid(geometry, float8)
   RETURNS geometry
   AS 'SELECT SnapToGrid($1, 0, 0, $2, $2)'
   LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- SnapToGrid(input, point_offsets, xsize, ysize, zsize, msize)
CREATE OR REPLACE FUNCTION SnapToGrid(geometry, geometry, float8, float8, float8, float8)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_snaptogrid_pointoff'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION segmentize(geometry, float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_segmentize2d'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

---------------------------------------------------------------
-- LRS
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION line_interpolate_point(geometry, float8)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_line_interpolate_point'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION line_substring(geometry, float8, float8)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_line_substring'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION line_locate_point(geometry, geometry)
   RETURNS float8
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_line_locate_point'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION locate_between_measures(geometry, float8, float8)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_locate_between_m'
	LANGUAGE 'C' IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION locate_along_measure(geometry, float8)
	RETURNS geometry
	AS 'SELECT locate_between_measures($1, $2, $2)'
	LANGUAGE 'sql' IMMUTABLE STRICT;

---------------------------------------------------------------
-- GEOS
---------------------------------------------------------------

CREATE OR REPLACE FUNCTION intersection(geometry,geometry)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','intersection'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION buffer(geometry,float8)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','buffer'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION buffer(geometry,float8,integer)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','buffer'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);
   
CREATE OR REPLACE FUNCTION convexhull(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','convexhull'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);
  
  
CREATE OR REPLACE FUNCTION difference(geometry,geometry)
	RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','difference'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);
   
CREATE OR REPLACE FUNCTION boundary(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','boundary'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION symdifference(geometry,geometry)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','symdifference'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);


CREATE OR REPLACE FUNCTION symmetricdifference(geometry,geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','symdifference'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);


CREATE OR REPLACE FUNCTION GeomUnion(geometry,geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','geomunion'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE AGGREGATE MemGeomUnion (
	basetype = geometry,
	sfunc = geomunion,
	stype = geometry
	);

CREATE OR REPLACE FUNCTION unite_garray (geometry[])
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable); 

CREATE AGGREGATE GeomUnion (
	sfunc = geom_accum,
	basetype = geometry,
	stype = geometry[],
	finalfunc = unite_garray
	);


CREATE OR REPLACE FUNCTION relate(geometry,geometry)
   RETURNS text
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','relate_full'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION relate(geometry,geometry,text)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','relate_pattern'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION disjoint(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION touches(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION intersects(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION crosses(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION within(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION contains(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION overlaps(geometry,geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION IsValid(geometry)
   RETURNS boolean
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'isvalid'
   LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GEOSnoop(geometry)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'GEOSnoop'
   LANGUAGE 'C' VOLATILE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION JTSnoop(geometry)
   RETURNS geometry
   AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'JTSnoop'
   LANGUAGE 'C' VOLATILE STRICT; -- WITH (isstrict,iscachable);

-- This is also available w/out GEOS 
CREATE OR REPLACE FUNCTION Centroid(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION IsRing(geometry)
	RETURNS boolean
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PointOnSurface(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);
	
CREATE OR REPLACE FUNCTION IsSimple(geometry)
	RETURNS boolean
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'issimple'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION Equals(geometry,geometry)
	RETURNS boolean
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','geomequals'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-----------------------------------------------------------------------
-- SVG OUTPUT
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION AsSVG(geometry,int4,int4)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','assvg_geometry'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsSVG(geometry,int4)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','assvg_geometry'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsSVG(geometry)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','assvg_geometry'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-----------------------------------------------------------------------
-- GML OUTPUT
-----------------------------------------------------------------------
-- AsGML(geom, precision, version)
CREATE OR REPLACE FUNCTION AsGML(geometry, int4, int4)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asGML'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- AsGML(geom, precision) / version=2
CREATE OR REPLACE FUNCTION AsGML(geometry, int4)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asGML'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

-- AsGML(geom) / precision=15 version=2
CREATE OR REPLACE FUNCTION AsGML(geometry)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asGML'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

------------------------------------------------------------------------
-- OGC defined
------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION NumPoints(geometry)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_numpoints_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION NumGeometries(geometry)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_numgeometries_collection'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION GeometryN(geometry,integer)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_geometryn_collection'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION Dimension(geometry)
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_dimension'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION ExterioRring(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_exteriorring_polygon'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION NumInteriorRings(geometry)
	RETURNS integer
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_numinteriorrings_polygon'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION NumInteriorRing(geometry)
	RETURNS integer
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_numinteriorrings_polygon'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION InteriorRingN(geometry,integer)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_interiorringn_polygon'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION GeometryType(geometry)
	RETURNS text
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_getTYPE'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION PointN(geometry,integer)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_pointn_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION X(geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_x_point'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION Y(geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_y_point'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION Z(geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_z_point'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION M(geometry)
	RETURNS float8
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_m_point'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION StartPoint(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_startpoint_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION EndPoint(geometry)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_endpoint_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION IsClosed(geometry)
	RETURNS boolean
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_isclosed_linestring'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION IsEmpty(geometry)
	RETURNS boolean
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'LWGEOM_isempty'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict);

CREATE OR REPLACE FUNCTION SRID(geometry) 
	RETURNS int4
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_getSRID'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);
	
CREATE OR REPLACE FUNCTION SetSRID(geometry,int4) 
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_setSRID'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);	
	
CREATE OR REPLACE FUNCTION AsBinary(geometry)
	RETURNS bytea
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asBinary'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsBinary(geometry,text)
	RETURNS bytea
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asBinary'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION AsText(geometry)
	RETURNS TEXT
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_asText'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeometryFromText(text)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_from_text'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeometryFromText(text, int4)
        RETURNS geometry
        AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_from_text'
        LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomFromText(text)
	RETURNS geometry AS 'SELECT geometryfromtext($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomFromText(text, int4)
	RETURNS geometry AS 'SELECT geometryfromtext($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PointFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = ''POINT''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PointFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = ''POINT''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LineFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = ''LINESTRING''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LineFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = ''LINESTRING''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LineStringFromText(text)
	RETURNS geometry
	AS 'SELECT LineFromText($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LineStringFromText(text, int4)
	RETURNS geometry
	AS 'SELECT LineFromText($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolyFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = ''POLYGON''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolyFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = ''POLYGON''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolygonFromText(text, int4)
	RETURNS geometry
	AS 'SELECT PolyFromText($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolygonFromText(text)
	RETURNS geometry
	AS 'SELECT PolyFromText($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MLineFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = ''MULTILINESTRING''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MLineFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = ''MULTILINESTRING''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiLineStringFromText(text)
	RETURNS geometry
	AS 'SELECT MLineFromText($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiLineStringFromText(text, int4)
	RETURNS geometry
	AS 'SELECT MLineFromText($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPointFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = ''MULTIPOINT''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPointFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = ''MULTIPOINT''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPointFromText(text, int4)
	RETURNS geometry
	AS 'SELECT MPointFromText($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPointFromText(text)
	RETURNS geometry
	AS 'SELECT MPointFromText($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPolyFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = ''MULTIPOLYGON''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPolyFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = ''MULTIPOLYGON''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPolygonFromText(text, int4)
	RETURNS geometry
	AS 'SELECT MPolyFromText($1, $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPolygonFromText(text)
	RETURNS geometry
	AS 'SELECT MPolyFromText($1)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomCollFromText(text, int4)
	RETURNS geometry
	AS '
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = ''GEOMETRYCOLLECTION''
	THEN GeomFromText($1,$2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomCollFromText(text)
	RETURNS geometry
	AS '
	SELECT CASE
	WHEN geometrytype(GeomFromText($1)) = ''GEOMETRYCOLLECTION''
	THEN GeomFromText($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomFromWKB(bytea)
	RETURNS geometry
	AS '/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1','LWGEOM_from_WKB'
	LANGUAGE 'C' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomFromWKB(bytea, int)
	RETURNS geometry
	AS 'SELECT setSRID(GeomFromWKB($1), $2)'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PointFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''POINT''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PointFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''POINT''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LineFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''LINESTRING''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LineFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''LINESTRING''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LinestringFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''LINESTRING''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION LinestringFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''LINESTRING''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolyFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''POLYGON''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolyFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''POLYGON''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolygonFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = ''POLYGON''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION PolygonFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''POLYGON''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPointFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = ''MULTIPOINT''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPointFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''MULTIPOINT''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPointFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = ''MULTIPOINT''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPointFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''MULTIPOINT''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiLineFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''MULTILINESTRING''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiLineFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''MULTILINESTRING''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MLineFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''MULTILINESTRING''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MLineFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''MULTILINESTRING''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPolyFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''MULTIPOLYGON''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MPolyFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''MULTIPOLYGON''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPolyFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = ''MULTIPOLYGON''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION MultiPolyFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = ''MULTIPOLYGON''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomCollFromWKB(bytea, int)
	RETURNS geometry
	AS '
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = ''GEOMETRYCOLLECTION''
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

CREATE OR REPLACE FUNCTION GeomCollFromWKB(bytea)
	RETURNS geometry
	AS '
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1)) = ''GEOMETRYCOLLECTION''
	THEN GeomFromWKB($1)
	ELSE NULL END
	'
	LANGUAGE 'SQL' IMMUTABLE STRICT; -- WITH (isstrict,iscachable);

--
-- SFSQL 1.1
--
-- BdPolyFromText(multiLineStringTaggedText String, SRID Integer): Polygon
--
--  Construct a Polygon given an arbitrary
--  collection of closed linestrings as a
--  MultiLineString text representation.
--
-- This is a PLPGSQL function rather then an SQL function
-- To avoid double call of BuildArea (one to get GeometryType
-- and another to actual return, in a CASE WHEN construct).
-- Also, we profit from plpgsql to RAISE exceptions.
--
CREATE OR REPLACE FUNCTION BdPolyFromText(text, integer)
RETURNS geometry
AS '
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION ''Input is not a MultiLinestring'';
	END IF;

	geom := BuildArea(mline);

	IF GeometryType(geom) != ''POLYGON''
	THEN
		RAISE EXCEPTION ''Input returns more then a single polygon, try using BdMPolyFromText instead'';
	END IF;

	RETURN geom;
END;
'
LANGUAGE 'plpgsql' IMMUTABLE STRICT; 

--
-- SFSQL 1.1
--
-- BdMPolyFromText(multiLineStringTaggedText String, SRID Integer): MultiPolygon
--
--  Construct a MultiPolygon given an arbitrary
--  collection of closed linestrings as a
--  MultiLineString text representation.
--
-- This is a PLPGSQL function rather then an SQL function
-- To raise an exception in case of invalid input.
--
CREATE OR REPLACE FUNCTION BdMPolyFromText(text, integer)
RETURNS geometry
AS '
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION ''Input is not a MultiLinestring'';
	END IF;

	geom := multi(BuildArea(mline));

	RETURN geom;
END;
'
LANGUAGE 'plpgsql' IMMUTABLE STRICT; 

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- $Id: long_xact.sql 2406 2006-07-07 13:56:52Z strk $
--
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.refractions.net
-- Copyright 2001-2003 Refractions Research Inc.
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--  
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -





-----------------------------------------------------------------------
-- LONG TERM LOCKING
-----------------------------------------------------------------------

-- UnlockRows(authid)
-- removes all locks held by the given auth
-- returns the number of locks released
CREATE OR REPLACE FUNCTION UnlockRows(text)
	RETURNS int
	AS '
DECLARE
	ret int;
BEGIN

	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION ''Long transaction support disabled, use EnableLongTransaction() to enable.'';
	END IF;

	EXECUTE ''DELETE FROM authorization_table where authid = '' ||
		quote_literal($1);

	GET DIAGNOSTICS ret = ROW_COUNT;

	RETURN ret;
END;
'
LANGUAGE 'plpgsql' VOLATILE STRICT;

-- LockRow([schema], table, rowid, auth, [expires]) 
-- Returns 1 if successfully obtained the lock, 0 otherwise
CREATE OR REPLACE FUNCTION LockRow(text, text, text, text, timestamp)
	RETURNS int
	AS '
DECLARE
	myschema alias for $1;
	mytable alias for $2;
	myrid   alias for $3;
	authid alias for $4;
	expires alias for $5;
	ret int;
	mytoid oid;
	myrec RECORD;
	
BEGIN

	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION ''Long transaction support disabled, use EnableLongTransaction() to enable.'';
	END IF;

	EXECUTE ''DELETE FROM authorization_table WHERE expires < now()''; 

	SELECT c.oid INTO mytoid FROM pg_class c, pg_namespace n
		WHERE c.relname = mytable
		AND c.relnamespace = n.oid
		AND n.nspname = myschema;

	-- RAISE NOTICE ''toid: %'', mytoid;

	FOR myrec IN SELECT * FROM authorization_table WHERE 
		toid = mytoid AND rid = myrid
	LOOP
		IF myrec.authid != authid THEN
			RETURN 0;
		ELSE
			RETURN 1;
		END IF;
	END LOOP;

	EXECUTE ''INSERT INTO authorization_table VALUES (''||
		quote_literal(mytoid)||'',''||quote_literal(myrid)||
		'',''||quote_literal(expires)||
		'',''||quote_literal(authid) ||'')'';

	GET DIAGNOSTICS ret = ROW_COUNT;

	RETURN ret;
END;'
LANGUAGE 'plpgsql' VOLATILE STRICT;

-- LockRow(schema, table, rid, authid);
CREATE OR REPLACE FUNCTION LockRow(text, text, text, text)
	RETURNS int
	AS
'SELECT LockRow($1, $2, $3, $4, now()::timestamp+''1:00'');'
	LANGUAGE 'sql' VOLATILE STRICT;

-- LockRow(table, rid, authid);
CREATE OR REPLACE FUNCTION LockRow(text, text, text)
	RETURNS int
	AS
'SELECT LockRow(current_schema(), $1, $2, $3, now()::timestamp+''1:00'');'
	LANGUAGE 'sql' VOLATILE STRICT;

-- LockRow(schema, table, rid, expires);
CREATE OR REPLACE FUNCTION LockRow(text, text, text, timestamp)
	RETURNS int
	AS
'SELECT LockRow(current_schema(), $1, $2, $3, $4);'
	LANGUAGE 'sql' VOLATILE STRICT;


CREATE OR REPLACE FUNCTION AddAuth(text)
	RETURNS BOOLEAN
	AS '
DECLARE
	lockid alias for $1;
	okay boolean;
	myrec record;
BEGIN
	-- check to see if table exists
	--  if not, CREATE TEMP TABLE mylock (transid xid, lockcode text)
	okay := ''f'';
	FOR myrec IN SELECT * FROM pg_class WHERE relname = ''temp_lock_have_table'' LOOP
		okay := ''t'';
	END LOOP; 
	IF (okay <> ''t'') THEN 
		CREATE TEMP TABLE temp_lock_have_table (transid xid, lockcode text);
			-- this will only work from pgsql7.4 up
			-- ON COMMIT DELETE ROWS;
	END IF;

	--  INSERT INTO mylock VALUES ( $1)
--	EXECUTE ''INSERT INTO temp_lock_have_table VALUES ( ''||
--		quote_literal(getTransactionID()) || '','' ||
--		quote_literal(lockid) ||'')'';

	INSERT INTO temp_lock_have_table VALUES (getTransactionID(), lockid);

	RETURN true::boolean;
END;
'
LANGUAGE PLPGSQL;
 

-- CheckAuth( <schema>, <table>, <ridcolumn> )
--
-- Returns 0
--
CREATE OR REPLACE FUNCTION CheckAuth(text, text, text)
	RETURNS INT
	AS '
DECLARE
	schema text;
BEGIN
	IF NOT LongTransactionsEnabled() THEN
		RAISE EXCEPTION ''Long transaction support disabled, use EnableLongTransaction() to enable.'';
	END IF;

	if ( $1 != '''' ) THEN
		schema = $1;
	ELSE
		SELECT current_schema() into schema;
	END IF;

	-- TODO: check for an already existing trigger ?

	EXECUTE ''CREATE TRIGGER check_auth BEFORE UPDATE OR DELETE ON '' 
		|| quote_ident(schema) || ''.'' || quote_ident($2)
		||'' FOR EACH ROW EXECUTE PROCEDURE CheckAuthTrigger(''
		|| quote_literal($3) || '')'';

	RETURN 0;
END;
'
LANGUAGE 'plpgsql';

-- CheckAuth(<table>, <ridcolumn>)
CREATE OR REPLACE FUNCTION CheckAuth(text, text)
	RETURNS INT
	AS
	'SELECT CheckAuth('''', $1, $2)'
	LANGUAGE 'SQL';

CREATE OR REPLACE FUNCTION CheckAuthTrigger()
	RETURNS trigger AS 
	'/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'check_authorization'
	LANGUAGE C;

CREATE OR REPLACE FUNCTION GetTransactionID()
	RETURNS xid AS 
	'/usr/lib/postgresql/8.1/lib/liblwgeom.so.1.1', 'getTransactionID'
	LANGUAGE C;


--
-- Enable Long transactions support
--
--  Creates the authorization_table if not already existing
--
CREATE OR REPLACE FUNCTION EnableLongTransactions()
	RETURNS TEXT
	AS '
DECLARE
	query text;
	exists bool;
	rec RECORD;

BEGIN

	exists = ''f'';
	FOR rec IN SELECT * FROM pg_class WHERE relname = ''authorization_table''
	LOOP
		exists = ''t'';
	END LOOP;

	IF NOT exists
	THEN
		query = ''CREATE TABLE authorization_table (
			toid oid, -- table oid
			rid text, -- row id
			expires timestamp,
			authid text
		)'';
		EXECUTE query;
	END IF;

	exists = ''f'';
	FOR rec IN SELECT * FROM pg_class WHERE relname = ''authorized_tables''
	LOOP
		exists = ''t'';
	END LOOP;

	IF NOT exists THEN
		query = ''CREATE VIEW authorized_tables AS '' ||
			''SELECT '' ||
			''n.nspname as schema, '' ||
			''c.relname as table, trim('' ||
			quote_literal(chr(92) || ''000'') ||
			'' from t.tgargs) as id_column '' ||
			''FROM pg_trigger t, pg_class c, pg_proc p '' ||
			'', pg_namespace n '' ||
			''WHERE p.proname = '' || quote_literal(''checkauthtrigger'') ||
			'' AND c.relnamespace = n.oid'' ||
			'' AND t.tgfoid = p.oid and t.tgrelid = c.oid'';
		EXECUTE query;
	END IF;

	RETURN ''Long transactions support enabled'';
END;
'
LANGUAGE 'plpgsql';

--
-- Check if Long transactions support is enabled
--
CREATE OR REPLACE FUNCTION LongTransactionsEnabled()
	RETURNS bool
AS '
DECLARE
	rec RECORD;
BEGIN
	FOR rec IN SELECT oid FROM pg_class WHERE relname = ''authorized_tables''
	LOOP
		return ''t'';
	END LOOP;
	return ''f'';
END;
'
LANGUAGE 'plpgsql';

--
-- Disable Long transactions support
--
--  (1) Drop any long_xact trigger 
--  (2) Drop the authorization_table
--  (3) KEEP the authorized_tables view
--
CREATE OR REPLACE FUNCTION DisableLongTransactions()
	RETURNS TEXT
	AS '
DECLARE
	query text;
	exists bool;
	rec RECORD;

BEGIN

	--
	-- Drop all triggers applied by CheckAuth()
	--
	FOR rec IN
		SELECT c.relname, t.tgname, t.tgargs FROM pg_trigger t, pg_class c, pg_proc p
		WHERE p.proname = ''checkauthtrigger'' and t.tgfoid = p.oid and t.tgrelid = c.oid
	LOOP
		EXECUTE ''DROP TRIGGER '' || quote_ident(rec.tgname) ||
			'' ON '' || quote_ident(rec.relname);
	END LOOP;

	--
	-- Drop the authorization_table table
	--
	FOR rec IN SELECT * FROM pg_class WHERE relname = ''authorization_table'' LOOP
		DROP TABLE authorization_table;
	END LOOP;

	--
	-- Drop the authorized_tables view
	--
	FOR rec IN SELECT * FROM pg_class WHERE relname = ''authorized_tables'' LOOP
		DROP VIEW authorized_tables;
	END LOOP;

	RETURN ''Long transactions support disabled'';
END;
'
LANGUAGE 'plpgsql';

---------------------------------------------------------------
-- END
---------------------------------------------------------------


---------------------------------------------------------------
-- END
---------------------------------------------------------------

COMMIT;

