--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases
--

DROP DATABASE faersdb;




--
-- Drop roles
--

DROP ROLE faers_data_admin;
DROP ROLE faers_web_manager;
DROP ROLE faers_wwweb_client;
DROP ROLE faers_wwweb_guest;
DROP ROLE postgres;
DROP ROLE www_clients;
DROP ROLE www_guests;


--
-- Roles
--

CREATE ROLE faers_data_admin;
ALTER ROLE faers_data_admin WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md56e3af104e15461a066858be37a09058f' VALID UNTIL 'infinity';
CREATE ROLE faers_web_manager;
ALTER ROLE faers_web_manager WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5a58a86c0fc3f1007dac5b702f3c1b9e9' VALID UNTIL 'infinity';
CREATE ROLE faers_wwweb_client;
ALTER ROLE faers_wwweb_client WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md52fac1d89eacc80efb92ebea6fafff356' VALID UNTIL 'infinity';
CREATE ROLE faers_wwweb_guest;
ALTER ROLE faers_wwweb_guest WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md58a270a6f318e2c6fa4c77e6a17a25d0b' VALID UNTIL 'infinity';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md59b83cb4e5732ba96677379da0fed075b';
CREATE ROLE www_clients;
ALTER ROLE www_clients WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';
CREATE ROLE www_guests;
ALTER ROLE www_guests WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';


--
-- Role memberships
--

GRANT www_clients TO faers_wwweb_client GRANTED BY postgres;
GRANT www_guests TO faers_wwweb_guest GRANTED BY postgres;




--
-- Database creation
--

CREATE DATABASE faersdb WITH TEMPLATE = template0 OWNER = faers_data_admin;
REVOKE CONNECT,TEMPORARY ON DATABASE faersdb FROM PUBLIC;
GRANT CONNECT,TEMPORARY ON DATABASE faersdb TO www_clients;
GRANT CONNECT,TEMPORARY ON DATABASE faersdb TO www_guests;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect faersdb

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: faers; Type: SCHEMA; Schema: -; Owner: faers_data_admin
--

CREATE SCHEMA faers;


ALTER SCHEMA faers OWNER TO faers_data_admin;

--
-- Name: faers_users; Type: SCHEMA; Schema: -; Owner: faers_web_manager
--

CREATE SCHEMA faers_users;


ALTER SCHEMA faers_users OWNER TO faers_web_manager;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = faers, pg_catalog;

--
-- Name: get_reactions(text, text); Type: FUNCTION; Schema: faers; Owner: postgres
--

CREATE FUNCTION get_reactions(drugname text, manufacturername text) RETURNS TABLE(drug_name character varying, quantity bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	DROP TABLE IF EXISTS temp_openfda_drug_search;
	CREATE TEMPORARY TABLE temp_openfda_drug_search AS
		SELECT openfda_id FROM faers.openfda_drug_info_manufacturer_name WHERE openfda_id IN
			(
			SELECT 	
				openfda_id
			FROM 
				faers.openfda_drug_info_brand_name
			WHERE
				brand_name = drugName 
			UNION
			SELECT 
				openfda_id
			FROM 
				faers.openfda_drug_info_generic_name
			WHERE 
				generic_name = drugName
			) AND manufacturer_name = manufacturerName;

	DROP TABLE IF EXISTS temp_drug_search;
	CREATE TEMPORARY TABLE temp_drug_search AS
		(
		SELECT d.id FROM faers.drug d JOIN faers.openfda_drug_info_manufacturer_name o ON d.openfda_drug_info_id = o.openfda_id 
			WHERE d.medicinal_product = drugName AND o.manufacturer_name = manufacturerName
		UNION
		SELECT * FROM temp_openfda_drug_search	
		);

	RETURN QUERY SELECT meddra_pt, count(meddra_pt) AS count FROM faers.reaction WHERE id IN
		(
		SELECT reaction_id FROM faers.patient_reaction_mapping WHERE patient_id IN
			(
			SELECT patient_id FROM faers.patient_drug_mapping WHERE drug_id IN
				(
				SELECT * FROM temp_openfda_drug_search
				)
			)
		)
	GROUP BY(meddra_pt);
END;
$$;


ALTER FUNCTION faers.get_reactions(drugname text, manufacturername text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: drug; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE drug (
    id bigint NOT NULL,
    administration_route smallint,
    characterization smallint,
    indication text,
    medicinal_product text,
    openfda_drug_info_id bigint
);


ALTER TABLE drug OWNER TO faers_data_admin;

--
-- Name: drug_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE drug_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE drug_id_seq OWNER TO faers_data_admin;

--
-- Name: drug_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE drug_id_seq OWNED BY drug.id;


--
-- Name: openfda_drug_info_brand_name; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_brand_name (
    openfda_id bigint NOT NULL,
    brand_name character varying(255)
);


ALTER TABLE openfda_drug_info_brand_name OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_generic_name; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_generic_name (
    openfda_id bigint NOT NULL,
    generic_name text
);


ALTER TABLE openfda_drug_info_generic_name OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_manufacturer_name; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_manufacturer_name (
    openfda_id bigint NOT NULL,
    manufacturer_name character varying(255)
);


ALTER TABLE openfda_drug_info_manufacturer_name OWNER TO faers_data_admin;

--
-- Name: drug_short; Type: VIEW; Schema: faers; Owner: faers_data_admin
--

CREATE VIEW drug_short AS
 SELECT DISTINCT unnest(string_to_array(concat_ws(';*; '::text, d.medicinal_product, obn.brand_name, ogn.generic_name), ';*; '::text)) AS drug_name,
    omn.manufacturer_name
   FROM (((drug d
     JOIN openfda_drug_info_brand_name obn ON ((d.openfda_drug_info_id = obn.openfda_id)))
     JOIN openfda_drug_info_generic_name ogn ON ((d.openfda_drug_info_id = ogn.openfda_id)))
     JOIN openfda_drug_info_manufacturer_name omn ON ((d.openfda_drug_info_id = omn.openfda_id)));


ALTER TABLE drug_short OWNER TO faers_data_admin;

--
-- Name: event; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE event (
    id bigint NOT NULL
);


ALTER TABLE event OWNER TO faers_data_admin;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_id_seq OWNER TO faers_data_admin;

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE event_id_seq OWNED BY event.id;


--
-- Name: event_result; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE event_result (
    id bigint NOT NULL,
    patient_id bigint
);


ALTER TABLE event_result OWNER TO faers_data_admin;

--
-- Name: event_result_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE event_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE event_result_id_seq OWNER TO faers_data_admin;

--
-- Name: event_result_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE event_result_id_seq OWNED BY event_result.id;


--
-- Name: event_result_mapping; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE event_result_mapping (
    event_id bigint NOT NULL,
    result_id bigint NOT NULL
);


ALTER TABLE event_result_mapping OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info (
    id bigint NOT NULL
);


ALTER TABLE openfda_drug_info OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE openfda_drug_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE openfda_drug_info_id_seq OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE openfda_drug_info_id_seq OWNED BY openfda_drug_info.id;


--
-- Name: openfda_drug_info_substance_name; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_substance_name (
    openfda_id bigint NOT NULL,
    substance_name character varying(255)
);


ALTER TABLE openfda_drug_info_substance_name OWNER TO faers_data_admin;

--
-- Name: patient; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE patient (
    id bigint NOT NULL,
    onset_age character varying(255),
    onset_age_unit smallint,
    sex smallint,
    weight real
);


ALTER TABLE patient OWNER TO faers_data_admin;

--
-- Name: patient_drug_mapping; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE patient_drug_mapping (
    patient_id bigint NOT NULL,
    drug_id bigint NOT NULL
);


ALTER TABLE patient_drug_mapping OWNER TO faers_data_admin;

--
-- Name: patient_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE patient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE patient_id_seq OWNER TO faers_data_admin;

--
-- Name: patient_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE patient_id_seq OWNED BY patient.id;


--
-- Name: patient_reaction_mapping; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE patient_reaction_mapping (
    patient_id bigint NOT NULL,
    reaction_id bigint NOT NULL
);


ALTER TABLE patient_reaction_mapping OWNER TO faers_data_admin;

--
-- Name: reaction; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE reaction (
    id bigint NOT NULL,
    meddra_pt character varying(255)
);


ALTER TABLE reaction OWNER TO faers_data_admin;

--
-- Name: reaction_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE reaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE reaction_id_seq OWNER TO faers_data_admin;

--
-- Name: reaction_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE reaction_id_seq OWNED BY reaction.id;


SET search_path = faers_users, pg_catalog;

--
-- Name: client; Type: TABLE; Schema: faers_users; Owner: faers_web_manager
--

CREATE TABLE client (
);


ALTER TABLE client OWNER TO faers_web_manager;

--
-- Name: prefered_drug; Type: TABLE; Schema: faers_users; Owner: faers_web_manager
--

CREATE TABLE prefered_drug (
);


ALTER TABLE prefered_drug OWNER TO faers_web_manager;

SET search_path = faers, pg_catalog;

--
-- Name: drug id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY drug ALTER COLUMN id SET DEFAULT nextval('drug_id_seq'::regclass);


--
-- Name: event id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event ALTER COLUMN id SET DEFAULT nextval('event_id_seq'::regclass);


--
-- Name: event_result id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result ALTER COLUMN id SET DEFAULT nextval('event_result_id_seq'::regclass);


--
-- Name: openfda_drug_info id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info ALTER COLUMN id SET DEFAULT nextval('openfda_drug_info_id_seq'::regclass);


--
-- Name: patient id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient ALTER COLUMN id SET DEFAULT nextval('patient_id_seq'::regclass);


--
-- Name: reaction id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY reaction ALTER COLUMN id SET DEFAULT nextval('reaction_id_seq'::regclass);


--
-- Name: drug drug_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY drug
    ADD CONSTRAINT drug_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: event_result event_result_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT event_result_pkey PRIMARY KEY (id);


--
-- Name: openfda_drug_info openfda_drug_info_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info
    ADD CONSTRAINT openfda_drug_info_pkey PRIMARY KEY (id);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (id);


--
-- Name: reaction reaction_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY reaction
    ADD CONSTRAINT reaction_pkey PRIMARY KEY (id);


--
-- Name: event_result_mapping uk_ca6b44da44s3qtgu8xjogauae; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result_mapping
    ADD CONSTRAINT uk_ca6b44da44s3qtgu8xjogauae UNIQUE (result_id);


--
-- Name: patient_drug_mapping uk_h95254w7t7qttp7wabdj3e34d; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_drug_mapping
    ADD CONSTRAINT uk_h95254w7t7qttp7wabdj3e34d UNIQUE (drug_id);


--
-- Name: drug fk_drug_openfda_drug_info_id_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY drug
    ADD CONSTRAINT fk_drug_openfda_drug_info_id_openfda_drug_info_id FOREIGN KEY (openfda_drug_info_id) REFERENCES openfda_drug_info(id);


--
-- Name: event_result_mapping fk_event_result_mapping_event_id_event_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result_mapping
    ADD CONSTRAINT fk_event_result_mapping_event_id_event_id FOREIGN KEY (event_id) REFERENCES event(id);


--
-- Name: event_result_mapping fk_event_result_mapping_result_id_result_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result_mapping
    ADD CONSTRAINT fk_event_result_mapping_result_id_result_id FOREIGN KEY (result_id) REFERENCES event_result(id);


--
-- Name: openfda_drug_info_brand_name fk_openfda_drug_info_brand_name_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_brand_name
    ADD CONSTRAINT fk_openfda_drug_info_brand_name_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_generic_name fk_openfda_drug_info_generic_name_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_generic_name
    ADD CONSTRAINT fk_openfda_drug_info_generic_name_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_manufacturer_name fk_openfda_drug_info_manufacturer_name_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_manufacturer_name
    ADD CONSTRAINT fk_openfda_drug_info_manufacturer_name_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_substance_name fk_openfda_drug_info_substance_name_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_substance_name
    ADD CONSTRAINT fk_openfda_drug_info_substance_name_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: patient_drug_mapping fk_patient_drug_mapping_drug_id_drug_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_drug_mapping
    ADD CONSTRAINT fk_patient_drug_mapping_drug_id_drug_id FOREIGN KEY (drug_id) REFERENCES drug(id);


--
-- Name: patient_drug_mapping fk_patient_drug_mapping_patient_id_patient_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_drug_mapping
    ADD CONSTRAINT fk_patient_drug_mapping_patient_id_patient_id FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: patient_reaction_mapping fk_patient_reaction_mapping_patient_id_patient_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_reaction_mapping
    ADD CONSTRAINT fk_patient_reaction_mapping_patient_id_patient_id FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: patient_reaction_mapping fk_patient_reaction_mapping_reaction_id_reaction_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_reaction_mapping
    ADD CONSTRAINT fk_patient_reaction_mapping_reaction_id_reaction_id FOREIGN KEY (reaction_id) REFERENCES reaction(id);


--
-- Name: event_result fk_result_patient_id_patient_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT fk_result_patient_id_patient_id FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: faers; Type: ACL; Schema: -; Owner: faers_data_admin
--

GRANT USAGE ON SCHEMA faers TO www_clients;
GRANT USAGE ON SCHEMA faers TO www_guests;


--
-- Name: faers_users; Type: ACL; Schema: -; Owner: faers_web_manager
--

GRANT USAGE ON SCHEMA faers_users TO www_clients;
GRANT USAGE ON SCHEMA faers_users TO www_guests;


--
-- Name: get_reactions(text, text); Type: ACL; Schema: faers; Owner: postgres
--

REVOKE ALL ON FUNCTION get_reactions(drugname text, manufacturername text) FROM PUBLIC;
GRANT ALL ON FUNCTION get_reactions(drugname text, manufacturername text) TO www_clients;
GRANT ALL ON FUNCTION get_reactions(drugname text, manufacturername text) TO www_guests;


--
-- Name: drug; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE drug TO www_guests;
GRANT SELECT ON TABLE drug TO www_clients;


--
-- Name: drug_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE drug_id_seq TO www_guests;
GRANT SELECT ON SEQUENCE drug_id_seq TO www_clients;


--
-- Name: openfda_drug_info_brand_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_brand_name TO www_guests;
GRANT SELECT ON TABLE openfda_drug_info_brand_name TO www_clients;


--
-- Name: openfda_drug_info_generic_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_generic_name TO www_guests;
GRANT SELECT ON TABLE openfda_drug_info_generic_name TO www_clients;


--
-- Name: openfda_drug_info_manufacturer_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_manufacturer_name TO www_guests;
GRANT SELECT ON TABLE openfda_drug_info_manufacturer_name TO www_clients;


--
-- Name: drug_short; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE drug_short TO www_clients;
GRANT SELECT ON TABLE drug_short TO www_guests;
GRANT ALL ON TABLE drug_short TO postgres;


--
-- Name: event; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE event TO www_guests;
GRANT SELECT ON TABLE event TO www_clients;


--
-- Name: event_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE event_id_seq TO www_guests;
GRANT SELECT ON SEQUENCE event_id_seq TO www_clients;


--
-- Name: event_result; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE event_result TO www_guests;
GRANT SELECT ON TABLE event_result TO www_clients;


--
-- Name: event_result_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE event_result_id_seq TO www_guests;
GRANT SELECT ON SEQUENCE event_result_id_seq TO www_clients;


--
-- Name: event_result_mapping; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE event_result_mapping TO www_guests;
GRANT SELECT ON TABLE event_result_mapping TO www_clients;


--
-- Name: openfda_drug_info; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info TO www_guests;
GRANT SELECT ON TABLE openfda_drug_info TO www_clients;


--
-- Name: openfda_drug_info_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE openfda_drug_info_id_seq TO www_guests;
GRANT SELECT ON SEQUENCE openfda_drug_info_id_seq TO www_clients;


--
-- Name: openfda_drug_info_substance_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_substance_name TO www_guests;
GRANT SELECT ON TABLE openfda_drug_info_substance_name TO www_clients;


--
-- Name: patient; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient TO www_guests;
GRANT SELECT ON TABLE patient TO www_clients;


--
-- Name: patient_drug_mapping; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient_drug_mapping TO www_guests;
GRANT SELECT ON TABLE patient_drug_mapping TO www_clients;


--
-- Name: patient_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE patient_id_seq TO www_guests;
GRANT SELECT ON SEQUENCE patient_id_seq TO www_clients;


--
-- Name: patient_reaction_mapping; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient_reaction_mapping TO www_guests;
GRANT SELECT ON TABLE patient_reaction_mapping TO www_clients;


--
-- Name: reaction; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE reaction TO www_guests;
GRANT SELECT ON TABLE reaction TO www_clients;


--
-- Name: reaction_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE reaction_id_seq TO www_guests;
GRANT SELECT ON SEQUENCE reaction_id_seq TO www_clients;


SET search_path = faers_users, pg_catalog;

--
-- Name: prefered_drug; Type: ACL; Schema: faers_users; Owner: faers_web_manager
--

GRANT SELECT ON TABLE prefered_drug TO www_clients;


SET search_path = faers, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: faers; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA faers REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA faers GRANT SELECT ON TABLES  TO www_clients;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA faers GRANT SELECT ON TABLES  TO www_guests;


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

