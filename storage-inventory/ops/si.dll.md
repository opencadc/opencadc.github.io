```
--
-- Server users and roles
--
--  In the following: 
--  o Change the password from XXXX to something of your choice: the password should be different for each account.
--  o Change XTAPADMINX throughout the file to the name of an account which will manage the TAP schema (e.g. tapadm)
--  o Change XTAPUSERX throughout the file to the name of an account which will manage the User query tables (e.g. tapuser)
--  o Change XINVADMX throughout the file to the name of an account which will manage the Inventory schema  (e.g. invadm)
--
CREATE ROLE XTAPADMINX;
ALTER ROLE XTAPADMINX WITH NOSUPERUSER NOINHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'XXXX';
CREATE ROLE XTAPUSERX;
ALTER ROLE XTAPUSERX WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'XXXX';
CREATE ROLE XINVADMX;
ALTER ROLE XINVADMX WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'XXXX';
--
-- Create database
--
-- Change the LOCATION to match what is used for the '-D` option to initdb.
CREATE TABLESPACE si_data OWNER postgres LOCATION '/var/lib/postgresql/data/si_data';
create database si_db with owner=postgres tablespace=si_data;
--
-- Users server privilleges
--
REVOKE ALL ON DATABASE si_db FROM PUBLIC;
REVOKE ALL ON DATABASE si_db FROM postgres;
GRANT ALL ON DATABASE  si_db TO postgres;
GRANT CONNECT,TEMPORARY ON DATABASE si_db TO PUBLIC;

GRANT ALL ON TABLESPACE si_data TO postgres;
GRANT ALL ON TABLESPACE si_data TO XTAPADMINX;
GRANT ALL ON TABLESPACE si_data TO XTAPUSERX;
GRANT ALL ON TABLESPACE si_data TO XINVADMX;
--
-- Per-Database Role Settings
--

ALTER ROLE XTAPADMINX IN DATABASE si_db SET default_tablespace TO 'si_data';
ALTER ROLE XTAPUSERX IN DATABASE si_db SET default_tablespace TO 'si_data';
ALTER ROLE XINVADMX IN DATABASE si_db SET default_tablespace TO 'si_data';
--
-- Crate schemas and extensions
--
\connect si_db

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
GRANT CONNECT ON DATABASE si_db to XINVADMX;
GRANT CONNECT ON DATABASE si_db to XTAPUSERX;
GRANT CONNECT ON DATABASE si_db  to XTAPADMINX;
GRANT CONNECT ON DATABASE si_db to public;
--
-- Inventory schema grants
--
GRANT ALL ON SCHEMA inventory TO XINVADMX;
GRANT USAGE ON SCHEMA inventory to XINVADMX;
GRANT USAGE ON SCHEMA inventory TO XTAPUSERX;
GRANT USAGE ON SCHEMA inventory to PUBLIC;
--
--Tap_schema grants
--
GRANT ALL ON SCHEMA tap_schema TO XTAPADMINX;
GRANT USAGE ON SCHEMA tap_schema to XTAPADMINX;
GRANT USAGE ON SCHEMA tap_schema TO XTAPUSERX;
--
--Tap upload grants
--
GRANT ALL ON SCHEMA tap_upload TO XTAPUSERX;
GRANT USAGE ON SCHEMA tap_upload to XTAPUSERX;
GRANT USAGE ON SCHEMA tap_upload to XTAPADMINX;
--
--Uws schema  grants
--
GRANT ALL ON SCHEMA uws TO XTAPADMINX;
GRANT USAGE on schema uws to XTAPADMINX;
GRANT USAGE ON SCHEMA uws to XTAPUSERX;
```
