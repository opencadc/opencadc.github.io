```
--
-- Server users and roles
--
--  Change the password from XXXX to something of your choice: the password should be different for each account.
CREATE ROLE tapadm;
ALTER ROLE tapadm WITH NOSUPERUSER NOINHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'XXXX';
CREATE ROLE tapuser;
ALTER ROLE tapuser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'XXXX';
CREATE ROLE invadm;
ALTER ROLE invadm WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'XXXX';
--
-- Create database
--
-- Change the LOCATION to match what is used for the '-D` option to initdb.
CREATE TABLESPACE global_data OWNER postgres LOCATION '/var/lib/postgresql/data/global_data';
create database global_db with owner=postgres tablespace=global_data;
--
-- Users server privilleges
--
REVOKE ALL ON DATABASE global_db FROM PUBLIC;
REVOKE ALL ON DATABASE global_db FROM postgres;
GRANT ALL ON DATABASE  global_db TO postgres;
GRANT CONNECT,TEMPORARY ON DATABASE global_db TO PUBLIC;

GRANT ALL ON TABLESPACE global_data TO postgres;
GRANT ALL ON TABLESPACE global_data TO tapadm;
GRANT ALL ON TABLESPACE global_data TO tapuser;
GRANT ALL ON TABLESPACE global_data TO invadm;
--
-- Per-Database Role Settings
--

ALTER ROLE tapadm IN DATABASE global_db SET default_tablespace TO 'global_data';
ALTER ROLE tapuser IN DATABASE global_db SET default_tablespace TO 'global_data';
ALTER ROLE invadm IN DATABASE global_db SET default_tablespace TO 'global_data';
--
-- Crate schemas and extensions
--
\connect global_db

SET default_transaction_read_only = off;
CREATE SCHEMA inventory;
ALTER SCHEMA inventory OWNER TO postgres;
CREATE SCHEMA tap_schema;
ALTER SCHEMA tap_schema OWNER TO postgres;
CREATE SCHEMA tap_upload;
ALTER SCHEMA tap_upload OWNER TO postgres;
CREATE SCHEMA uws;
ALTER SCHEMA uws OWNER TO postgres;
CREATE EXTENSION IF NOT EXISTS pg_repack;
CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';
CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;
COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';
CREATE EXTENSION IF NOT EXISTS pg_freespacemap WITH SCHEMA public;
COMMENT ON EXTENSION pg_freespacemap IS 'examine the free space map (FSM)';
CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;
COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';
CREATE EXTENSION IF NOT EXISTS pgrowlocks WITH SCHEMA public;
COMMENT ON EXTENSION pgrowlocks IS 'show row-level locking information';
--
-- Users grants to db objects
--
GRANT CONNECT ON DATABASE global_db to invadm;
GRANT CONNECT ON DATABASE global_db to tapuser;
GRANT CONNECT ON DATABASE global_db  to tapadm;
GRANT CONNECT ON DATABASE global_db to public;
--
-- Inventory schema grants
--
GRANT ALL ON SCHEMA inventory TO invadm;
GRANT USAGE ON SCHEMA inventory to invadm;
GRANT USAGE ON SCHEMA inventory TO tapuser;
GRANT USAGE ON SCHEMA inventory to PUBLIC;
--
--Tap_schema grants
--
GRANT ALL ON SCHEMA tap_schema TO tapadm;
GRANT USAGE ON SCHEMA tap_schema to tapadm;
GRANT USAGE ON SCHEMA tap_schema TO tapuser;
--
--Tap upload grants
--
GRANT ALL ON SCHEMA tap_upload TO tapuser;
GRANT USAGE ON SCHEMA tap_upload to tapuser;
GRANT USAGE ON SCHEMA tap_upload to tapadm;
--
--Uws schema  grants
--
GRANT ALL ON SCHEMA uws TO tapadm;
GRANT USAGE on schema uws to tapadm;
GRANT USAGE ON SCHEMA uws to tapuser;
```
