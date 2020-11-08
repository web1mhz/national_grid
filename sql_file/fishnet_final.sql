-- # postgis 기능사용하기 위한 명령어
create extension postgis;

-- # postgis기능 잘 설치되었는지 확인하기 위해서 공간좌표계 목록을 확인하기
select * from spatial_ref_sys;

-- postgis 기능을 이용해서 정규형태의 격자를 만들기 위한 함수

CREATE OR REPLACE FUNCTION __knps_grid_linearUnit_M(
	grid_count_x integer, grid_count_y integer,
	grid_size_x integer, grid_size_y integer,
	start_x double precision, start_y double precision,
	target_srid integer) RETURNS varchar AS
	
$$	
	DECLARE
		target_table_name text;
	BEGIN
-- 	EXECUTE format('SELECT __progworks_new_table_name(''%s'')', 'temp' ) INTO target_table_name;
	EXECUTE format ('SELECT (''%s'')', 'temp' ) INTO target_table_name;
 	EXECUTE format('CREATE TABLE IF NOT EXISTS %I AS SELECT i+1 AS col, j+1 AS row, ST_Translate(cell, i * %s + %s, j * %s + %s) AS geom
		from generate_series(0, %s - 1) AS I, generate_series(0, %s - 1) AS j,
		(SELECT ST_GeomFromText(''POLYGON((0 0, 0 %s, %s %s, %s 0,0 0))'') AS cell) AS ORIGIN;',	
		target_table_name,	
		grid_size_x, start_x,
		grid_size_y, start_y,
		grid_count_x, grid_count_y,
		grid_size_y, grid_size_x, grid_size_y, grid_size_x);
		
	EXECUTE format('SELECT UpdateGeometrySRID(''%I'', ''geom'', %s);', target_table_name, target_srid );	
	return target_table_name;
	END
$$

LANGUAGE plpgsql;


-- postgis 격자만들기를 위한 실행문장
SELECT __knps_grid_linearUnit_M(30, 30, 1000, 1000, 955000, 1937000, 5179);
SELECT __knps_grid_linearUnit_M(10, 10, 100000, 100000, 700000, 1300000, 5179);
SELECT __knps_grid_linearUnit_M(30, 30, 1, 1, 127.5, 38, 4326);
	
-- 기본 명령어 설명
-- select __progworks_rect_grid_on_linearUnit_m(행개수, 열개수, 격자크기, 격자크기, 시작위치, 시작위치, 좌표계번호)


SELECT i+1 AS col, j+1 AS row, ST_Translate(cell, i * 30 + 955000, j * 30 + 1937000) AS geom
		into target_table_name
		from generate_series(0, 30 - 1) AS I, generate_series(0, 30 - 1) AS j,
		(SELECT ST_GeomFromText('POLYGON((0 0, 0 30, 30 30, 30 0,0 0))') AS cell) AS origin;

SELECT UpdateGeometrySRID('target_table_name', 'geom', 5179);


-- 함수 이용하는 법

DO $$ 
DECLARE
   age integer := 40;
   korean_name varchar(10) := '김tg';
   alias_name varchar(50) := '2K';
   weight numeric(3,1) := 65.5;
BEGIN 
   RAISE NOTICE '%의 별명은 % 이고 나이는 %이며 몸무게는 %입니다.', 
       korean_name, alias_name, age, weight;
END $$;

DO $$
DECLARE
	col_x integer := 30;
	row_y integer := 30;
	size_x integer := 1000;
	size_y integer := 1000;
	start_x double precision := 955000;
	start_y double precision := 1937000;
	target_srid integer:=5179;	
	target_table_name text;
BEGIN

select 'tmp' into target_table_name;
CREATE TABLE IF NOT EXISTS target_table_name AS SELECT i+1 AS col, j+1 AS row, ST_Translate(cell, i * 30 + 955000, j * 30 + 1937000) AS geom		
		from generate_series(0, 30 - 1) AS I, generate_series(0, 30 - 1) AS j,
		(SELECT ST_GeomFromText('POLYGON((0 0, 0 30, 30 30, 30 0,0 0))') AS cell) AS origin;
		
END $$;
SELECT UpdateGeometrySRID('target_table_name', 'geom', 5179);


select * from temp;

-- 점, 선, 면 만들기

-- 폴리곤
SELECT ST_GeomFromText('POLYGON((0 0, 0 30, 30 30, 30 0,0 0))') AS cell into cell;

-- 점
SELECT ST_GeomFromText('POINT(127.5 38)', 4326) AS cell; 
select ST_SetSRID(ST_MakePoint(random(), random()), 4326) as cell;
select ST_GeomFromText('POINT(' || random()::text || ' ' || random()::text || ')', 4326) as cell;
select ST_GeomFromEWKT('SRID=4326; POINT(' || random()::text || ' ' || random()::text || ')') as cell;













