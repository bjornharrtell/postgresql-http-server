CREATE EXTENSION postgis;
DROP SCHEMA IF EXISTS testschema CASCADE;
CREATE SCHEMA testschema;
CREATE TABLE testschema.testtable (id SERIAL PRIMARY KEY, name varchar);
SELECT AddGeometryColumn('testschema', 'testtable', 'geom', 0, 'POINT', 2);
