-- Create table with spatial column
CREATE TABLE mytable (
  id SERIAL PRIMARY KEY,
  geom GEOMETRY(Point, 4326),
  name VARCHAR(128)
);
 
-- Add a spatial index
CREATE INDEX mytable_gix
  ON mytable
  USING GIST (geom);
 
-- Add a point
INSERT INTO mytable (geom) VALUES (
  ST_GeomFromText('POINT(127.5 38)', 4326)
);
 
-- Query for nearby points
select * from mytable;

SELECT id, name
FROM mytable
WHERE ST_DWithin(
  geom,
  ST_GeomFromText('POINT(0 0)', 4326),
  1000
);


-- 도로망 지오 테이블 생성

CREATE TABLE ROADS (ID serial, ROAD_NAME text, geom geometry(LINESTRING,4326) );
ALTER TABLE roads ADD COLUMN geom2 geometry(LINESTRINGZ,4326);

SELECT postgis_full_version();

SELECT version();

SELECT ST_Point(1, 2) AS MyFirstPoint;

SELECT ST_SetSRID(ST_Point(127.5, 38),4326);
SELECT ST_SetSRID(ST_Point(127.5, 38),5179);

SELECT ST_GeomFromText('POINT(-77.036548 38.895108)', 4326);
SELECT ST_AsEWKT('0101000020E6100000FD2E6CCD564253C0A93121E692724340');


SELECT ST_AsEWKT(ST_GeomFromText('POINT(-77.036548 38.895108)', 4326));

SELECT ST_GeomFromText('LINESTRING(-14 21,0 0,35 26)', 4326) AS MyCheckMark;

SELECT ST_GeomFromText('LINESTRING(52 218, 139 82, 262 207, 245 261, 207 267,
153 207, 125 235, 90 270, 55 244, 51 219, 52 218)') AS HeartLine;

SELECT ST_GeomFromText('POLYGON((0 1,1 -1,-1 -1,0 1))') As MyTriangle;
SELECT ST_GeomFromText('POLYGON((52 218, 139 82, 262 207, 245 261,
 207 267, 153 207, 125 235, 90 270,
 55 244, 51 219, 52 218))') As HeartPolygon;


CREATE TABLE roads(gid serial PRIMARY KEY, road_name character varying(100));
SELECT AddGeometryColumn('public', 'roads', 'geom', 4269, 'LINESTRING',2);

CREATE SCHEMA us; 




