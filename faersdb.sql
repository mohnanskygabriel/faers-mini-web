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
DROP ROLE faers_wwweb_host;
DROP ROLE postgres;
DROP ROLE www_clients;
DROP ROLE www_hosts;


--
-- Roles
--

CREATE ROLE faers_data_admin;
ALTER ROLE faers_data_admin WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md56e3af104e15461a066858be37a09058f' VALID UNTIL 'infinity';
CREATE ROLE faers_web_manager;
ALTER ROLE faers_web_manager WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5a58a86c0fc3f1007dac5b702f3c1b9e9' VALID UNTIL 'infinity';
CREATE ROLE faers_wwweb_client;
ALTER ROLE faers_wwweb_client WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md52fac1d89eacc80efb92ebea6fafff356' VALID UNTIL 'infinity';
CREATE ROLE faers_wwweb_host;
ALTER ROLE faers_wwweb_host WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md55ce26c4dd3cc0d15a770717c5cf228ba' VALID UNTIL 'infinity';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md59b83cb4e5732ba96677379da0fed075b';
CREATE ROLE www_clients;
ALTER ROLE www_clients WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';
CREATE ROLE www_hosts;
ALTER ROLE www_hosts WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS VALID UNTIL 'infinity';


--
-- Role memberships
--

GRANT www_clients TO faers_wwweb_client GRANTED BY postgres;
GRANT www_hosts TO faers_wwweb_host GRANTED BY postgres;




--
-- Database creation
--

CREATE DATABASE faersdb WITH TEMPLATE = template0 OWNER = faers_data_admin;
REVOKE CONNECT,TEMPORARY ON DATABASE faersdb FROM PUBLIC;
GRANT CONNECT ON DATABASE faersdb TO www_clients;
GRANT CONNECT ON DATABASE faersdb TO www_hosts;
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


SET search_path = faers, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_substance; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE active_substance (
    id bigint NOT NULL,
    name text
);


ALTER TABLE active_substance OWNER TO faers_data_admin;

--
-- Name: active_substance_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE active_substance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE active_substance_id_seq OWNER TO faers_data_admin;

--
-- Name: active_substance_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE active_substance_id_seq OWNED BY active_substance.id;


--
-- Name: drug; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE drug (
    id bigint NOT NULL,
    action_drug smallint,
    additional smallint,
    administration_route smallint,
    authorization_numb text,
    batch_numb text,
    characterization smallint,
    cumulative_dosage_numb character varying(255),
    cumulative_dosage_unit smallint,
    dosage_form text,
    doseage_text text,
    end_date text,
    end_date_format smallint,
    indication text,
    interval_dosage_definition smallint,
    interval_dosage_unit_numb character varying(255),
    recurre_administration smallint,
    separate_dosage_numb character varying(255),
    start_date text,
    start_date_format smallint,
    structure_dosage_numb text,
    structure_dosage_unit smallint,
    treatment_duration text,
    treatment_duration_unit smallint,
    medicinal_product text,
    active_substance_id bigint,
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
-- Name: event; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE event (
    id bigint NOT NULL,
    meta_id bigint
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
    company_numb character varying(255),
    duplicate smallint,
    fulfill_expedite_criteria character varying(255),
    occur_country character varying(255),
    primary_source_country character varying(255),
    receipt_date character varying(255),
    receipt_date_format character varying(255),
    receive_date character varying(255),
    receive_date_format character varying(255),
    safety_report character varying(255),
    safety_report_id character varying(9),
    safety_report_version character varying(255),
    serious character varying(255),
    seriousness_congenital_anomali character varying(255),
    seriousness_death character varying(255),
    seriousness_disabling character varying(255),
    seriousness_hospitalization character varying(255),
    seriousness_life_threatening character varying(255),
    seriousness_other character varying(255),
    transmission_date character varying(255),
    transmission_date_format character varying(255),
    patient_id bigint,
    primary_source_id bigint,
    receiver_id bigint,
    report_duplicate_id bigint,
    sender_id bigint
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
-- Name: faers_user; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE faers_user (
    id bigint NOT NULL,
    login character varying(255),
    mail character varying(255),
    pass character varying(64) NOT NULL,
    salt character varying(64) NOT NULL
);


ALTER TABLE faers_user OWNER TO faers_data_admin;

--
-- Name: faers_user_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE faers_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE faers_user_id_seq OWNER TO faers_data_admin;

--
-- Name: faers_user_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE faers_user_id_seq OWNED BY faers_user.id;


--
-- Name: meta; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE meta (
    id bigint NOT NULL,
    disclaimer text,
    last_updated character varying(255),
    license character varying(255),
    terms character varying(255),
    results_id bigint
);


ALTER TABLE meta OWNER TO faers_data_admin;

--
-- Name: meta_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meta_id_seq OWNER TO faers_data_admin;

--
-- Name: meta_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE meta_id_seq OWNED BY meta.id;


--
-- Name: meta_results; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE meta_results (
    id bigint NOT NULL,
    lim character varying(255),
    skip character varying(255),
    total character varying(255)
);


ALTER TABLE meta_results OWNER TO faers_data_admin;

--
-- Name: meta_results_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE meta_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE meta_results_id_seq OWNER TO faers_data_admin;

--
-- Name: meta_results_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE meta_results_id_seq OWNED BY meta_results.id;


--
-- Name: openfda_drug_info; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info (
    id bigint NOT NULL
);


ALTER TABLE openfda_drug_info OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_application_number; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_application_number (
    openfda_id bigint NOT NULL,
    application_number character varying(255)
);


ALTER TABLE openfda_drug_info_application_number OWNER TO faers_data_admin;

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
-- Name: openfda_drug_info_manufacturer_name; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_manufacturer_name (
    openfda_id bigint NOT NULL,
    manufacturer_name character varying(255)
);


ALTER TABLE openfda_drug_info_manufacturer_name OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_nui; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_nui (
    openfda_id bigint NOT NULL,
    nui character varying(255)
);


ALTER TABLE openfda_drug_info_nui OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_package_ndc; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_package_ndc (
    openfda_id bigint NOT NULL,
    package_ndc character varying(255)
);


ALTER TABLE openfda_drug_info_package_ndc OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_pharm_class_cs; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_pharm_class_cs (
    openfda_id bigint NOT NULL,
    pharm_class_cs character varying(255)
);


ALTER TABLE openfda_drug_info_pharm_class_cs OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_pharm_class_epc; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_pharm_class_epc (
    openfda_id bigint NOT NULL,
    pharm_class_epc character varying(255)
);


ALTER TABLE openfda_drug_info_pharm_class_epc OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_pharm_class_moa; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_pharm_class_moa (
    openfda_id bigint NOT NULL,
    pharm_class_moa character varying(255)
);


ALTER TABLE openfda_drug_info_pharm_class_moa OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_pharm_class_pe; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_pharm_class_pe (
    openfda_id bigint NOT NULL,
    pharm_class_pe character varying(255)
);


ALTER TABLE openfda_drug_info_pharm_class_pe OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_product_ndc; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_product_ndc (
    openfda_id bigint NOT NULL,
    product_ndc character varying(255)
);


ALTER TABLE openfda_drug_info_product_ndc OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_product_type; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_product_type (
    openfda_id bigint NOT NULL,
    product_type character varying(255)
);


ALTER TABLE openfda_drug_info_product_type OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_route; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_route (
    openfda_id bigint NOT NULL,
    route character varying(255)
);


ALTER TABLE openfda_drug_info_route OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_rxcui; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_rxcui (
    openfda_id bigint NOT NULL,
    rxcui character varying(255)
);


ALTER TABLE openfda_drug_info_rxcui OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_spl_id; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_spl_id (
    openfda_id bigint NOT NULL,
    spl_id character varying(255)
);


ALTER TABLE openfda_drug_info_spl_id OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_spl_set_id; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_spl_set_id (
    openfda_id bigint NOT NULL,
    spl_set_id character varying(255)
);


ALTER TABLE openfda_drug_info_spl_set_id OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_substance_name; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_substance_name (
    openfda_id bigint NOT NULL,
    substance_name character varying(255)
);


ALTER TABLE openfda_drug_info_substance_name OWNER TO faers_data_admin;

--
-- Name: openfda_drug_info_unii; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE openfda_drug_info_unii (
    openfda_id bigint NOT NULL,
    unii character varying(255)
);


ALTER TABLE openfda_drug_info_unii OWNER TO faers_data_admin;

--
-- Name: patient; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE patient (
    id bigint NOT NULL,
    onset_age character varying(255),
    onset_age_unit smallint,
    sex smallint,
    weight real,
    patient_death_id bigint
);


ALTER TABLE patient OWNER TO faers_data_admin;

--
-- Name: patient_death; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE patient_death (
    id bigint NOT NULL,
    death_date character varying(255),
    date_format smallint
);


ALTER TABLE patient_death OWNER TO faers_data_admin;

--
-- Name: patient_death_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE patient_death_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE patient_death_id_seq OWNER TO faers_data_admin;

--
-- Name: patient_death_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE patient_death_id_seq OWNED BY patient_death.id;


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
-- Name: preferred_drug; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE preferred_drug (
    faers_user_id bigint NOT NULL,
    drug_id bigint NOT NULL
);


ALTER TABLE preferred_drug OWNER TO faers_data_admin;

--
-- Name: primary_source; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE primary_source (
    id bigint NOT NULL,
    qualification smallint,
    reporter_country character varying(255)
);


ALTER TABLE primary_source OWNER TO faers_data_admin;

--
-- Name: primary_source_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE primary_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE primary_source_id_seq OWNER TO faers_data_admin;

--
-- Name: primary_source_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE primary_source_id_seq OWNED BY primary_source.id;


--
-- Name: reaction; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE reaction (
    id bigint NOT NULL,
    meddra_pt character varying(255),
    meddra_version_pt real,
    outcome smallint
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


--
-- Name: receiver; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE receiver (
    id bigint NOT NULL,
    organization character varying(255),
    type smallint
);


ALTER TABLE receiver OWNER TO faers_data_admin;

--
-- Name: receiver_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE receiver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE receiver_id_seq OWNER TO faers_data_admin;

--
-- Name: receiver_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE receiver_id_seq OWNED BY receiver.id;


--
-- Name: report_duplicate; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE report_duplicate (
    id bigint NOT NULL,
    duplicate_numb character varying(255),
    duplicate_source character varying(255)
);


ALTER TABLE report_duplicate OWNER TO faers_data_admin;

--
-- Name: report_duplicate_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE report_duplicate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE report_duplicate_id_seq OWNER TO faers_data_admin;

--
-- Name: report_duplicate_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE report_duplicate_id_seq OWNED BY report_duplicate.id;


--
-- Name: sender; Type: TABLE; Schema: faers; Owner: faers_data_admin
--

CREATE TABLE sender (
    id bigint NOT NULL,
    organization character varying(255),
    type character varying(255)
);


ALTER TABLE sender OWNER TO faers_data_admin;

--
-- Name: sender_id_seq; Type: SEQUENCE; Schema: faers; Owner: faers_data_admin
--

CREATE SEQUENCE sender_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sender_id_seq OWNER TO faers_data_admin;

--
-- Name: sender_id_seq; Type: SEQUENCE OWNED BY; Schema: faers; Owner: faers_data_admin
--

ALTER SEQUENCE sender_id_seq OWNED BY sender.id;


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
-- Name: active_substance id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY active_substance ALTER COLUMN id SET DEFAULT nextval('active_substance_id_seq'::regclass);


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
-- Name: faers_user id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY faers_user ALTER COLUMN id SET DEFAULT nextval('faers_user_id_seq'::regclass);


--
-- Name: meta id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY meta ALTER COLUMN id SET DEFAULT nextval('meta_id_seq'::regclass);


--
-- Name: meta_results id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY meta_results ALTER COLUMN id SET DEFAULT nextval('meta_results_id_seq'::regclass);


--
-- Name: openfda_drug_info id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info ALTER COLUMN id SET DEFAULT nextval('openfda_drug_info_id_seq'::regclass);


--
-- Name: patient id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient ALTER COLUMN id SET DEFAULT nextval('patient_id_seq'::regclass);


--
-- Name: patient_death id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_death ALTER COLUMN id SET DEFAULT nextval('patient_death_id_seq'::regclass);


--
-- Name: primary_source id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY primary_source ALTER COLUMN id SET DEFAULT nextval('primary_source_id_seq'::regclass);


--
-- Name: reaction id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY reaction ALTER COLUMN id SET DEFAULT nextval('reaction_id_seq'::regclass);


--
-- Name: receiver id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY receiver ALTER COLUMN id SET DEFAULT nextval('receiver_id_seq'::regclass);


--
-- Name: report_duplicate id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY report_duplicate ALTER COLUMN id SET DEFAULT nextval('report_duplicate_id_seq'::regclass);


--
-- Name: sender id; Type: DEFAULT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY sender ALTER COLUMN id SET DEFAULT nextval('sender_id_seq'::regclass);


--
-- Name: active_substance active_substance_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY active_substance
    ADD CONSTRAINT active_substance_pkey PRIMARY KEY (id);


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
-- Name: faers_user faers_user_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY faers_user
    ADD CONSTRAINT faers_user_pkey PRIMARY KEY (id);


--
-- Name: meta meta_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY meta
    ADD CONSTRAINT meta_pkey PRIMARY KEY (id);


--
-- Name: meta_results meta_results_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY meta_results
    ADD CONSTRAINT meta_results_pkey PRIMARY KEY (id);


--
-- Name: openfda_drug_info openfda_drug_info_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info
    ADD CONSTRAINT openfda_drug_info_pkey PRIMARY KEY (id);


--
-- Name: patient_death patient_death_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient_death
    ADD CONSTRAINT patient_death_pkey PRIMARY KEY (id);


--
-- Name: patient patient_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (id);


--
-- Name: primary_source primary_source_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY primary_source
    ADD CONSTRAINT primary_source_pkey PRIMARY KEY (id);


--
-- Name: reaction reaction_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY reaction
    ADD CONSTRAINT reaction_pkey PRIMARY KEY (id);


--
-- Name: receiver receiver_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY receiver
    ADD CONSTRAINT receiver_pkey PRIMARY KEY (id);


--
-- Name: report_duplicate report_duplicate_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY report_duplicate
    ADD CONSTRAINT report_duplicate_pkey PRIMARY KEY (id);


--
-- Name: sender sender_pkey; Type: CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY sender
    ADD CONSTRAINT sender_pkey PRIMARY KEY (id);


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
-- Name: drug fk_drug_active_substance_id_active_substance_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY drug
    ADD CONSTRAINT fk_drug_active_substance_id_active_substance_id FOREIGN KEY (active_substance_id) REFERENCES active_substance(id);


--
-- Name: drug fk_drug_openfda_drug_info_id_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY drug
    ADD CONSTRAINT fk_drug_openfda_drug_info_id_openfda_drug_info_id FOREIGN KEY (openfda_drug_info_id) REFERENCES openfda_drug_info(id);


--
-- Name: event fk_event_meta_id_meta_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event
    ADD CONSTRAINT fk_event_meta_id_meta_id FOREIGN KEY (meta_id) REFERENCES meta(id);


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
-- Name: meta fk_meta_results_id_results_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY meta
    ADD CONSTRAINT fk_meta_results_id_results_id FOREIGN KEY (results_id) REFERENCES meta_results(id);


--
-- Name: openfda_drug_info_application_number fk_openfda_drug_info_application_number_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_application_number
    ADD CONSTRAINT fk_openfda_drug_info_application_number_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


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
-- Name: openfda_drug_info_nui fk_openfda_drug_info_nui_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_nui
    ADD CONSTRAINT fk_openfda_drug_info_nui_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_package_ndc fk_openfda_drug_info_package_ndc_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_package_ndc
    ADD CONSTRAINT fk_openfda_drug_info_package_ndc_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_pharm_class_cs fk_openfda_drug_info_pharm_class_cs_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_pharm_class_cs
    ADD CONSTRAINT fk_openfda_drug_info_pharm_class_cs_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_pharm_class_epc fk_openfda_drug_info_pharm_class_epc_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_pharm_class_epc
    ADD CONSTRAINT fk_openfda_drug_info_pharm_class_epc_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_pharm_class_moa fk_openfda_drug_info_pharm_class_moa_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_pharm_class_moa
    ADD CONSTRAINT fk_openfda_drug_info_pharm_class_moa_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_pharm_class_pe fk_openfda_drug_info_pharm_class_pe_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_pharm_class_pe
    ADD CONSTRAINT fk_openfda_drug_info_pharm_class_pe_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_product_ndc fk_openfda_drug_info_product_ndc_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_product_ndc
    ADD CONSTRAINT fk_openfda_drug_info_product_ndc_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_product_type fk_openfda_drug_info_product_type_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_product_type
    ADD CONSTRAINT fk_openfda_drug_info_product_type_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_route fk_openfda_drug_info_route_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_route
    ADD CONSTRAINT fk_openfda_drug_info_route_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_rxcui fk_openfda_drug_info_rxcui_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_rxcui
    ADD CONSTRAINT fk_openfda_drug_info_rxcui_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_spl_id fk_openfda_drug_info_spl_id_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_spl_id
    ADD CONSTRAINT fk_openfda_drug_info_spl_id_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_spl_set_id fk_openfda_drug_info_spl_set_id_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_spl_set_id
    ADD CONSTRAINT fk_openfda_drug_info_spl_set_id_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_substance_name fk_openfda_drug_info_substance_name_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_substance_name
    ADD CONSTRAINT fk_openfda_drug_info_substance_name_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


--
-- Name: openfda_drug_info_unii fk_openfda_drug_info_unii_openfda_drug_info_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY openfda_drug_info_unii
    ADD CONSTRAINT fk_openfda_drug_info_unii_openfda_drug_info_id FOREIGN KEY (openfda_id) REFERENCES openfda_drug_info(id);


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
-- Name: patient fk_patient_patient_death_id_patient_death_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT fk_patient_patient_death_id_patient_death_id FOREIGN KEY (patient_death_id) REFERENCES patient_death(id);


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
-- Name: preferred_drug fk_preferred_drug_drug_id_drug_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY preferred_drug
    ADD CONSTRAINT fk_preferred_drug_drug_id_drug_id FOREIGN KEY (drug_id) REFERENCES drug(id);


--
-- Name: preferred_drug fk_preferred_drug_faers_user_id_faers_user_id_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY preferred_drug
    ADD CONSTRAINT fk_preferred_drug_faers_user_id_faers_user_id_id FOREIGN KEY (faers_user_id) REFERENCES faers_user(id);


--
-- Name: event_result fk_result_patient_id_patient_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT fk_result_patient_id_patient_id FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: event_result fk_result_primary_source_id_primary_source_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT fk_result_primary_source_id_primary_source_id FOREIGN KEY (primary_source_id) REFERENCES primary_source(id);


--
-- Name: event_result fk_result_receiver_id_receiver_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT fk_result_receiver_id_receiver_id FOREIGN KEY (receiver_id) REFERENCES receiver(id);


--
-- Name: event_result fk_result_report_duplicate_id_report_duplicate_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT fk_result_report_duplicate_id_report_duplicate_id FOREIGN KEY (report_duplicate_id) REFERENCES report_duplicate(id);


--
-- Name: event_result fk_result_sender_id_sender_id; Type: FK CONSTRAINT; Schema: faers; Owner: faers_data_admin
--

ALTER TABLE ONLY event_result
    ADD CONSTRAINT fk_result_sender_id_sender_id FOREIGN KEY (sender_id) REFERENCES sender(id);


--
-- Name: faers; Type: ACL; Schema: -; Owner: faers_data_admin
--

GRANT USAGE ON SCHEMA faers TO www_clients;
GRANT USAGE ON SCHEMA faers TO www_hosts;


--
-- Name: faers_users; Type: ACL; Schema: -; Owner: faers_web_manager
--

GRANT USAGE ON SCHEMA faers_users TO www_clients;
GRANT USAGE ON SCHEMA faers_users TO www_hosts;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: active_substance; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE active_substance TO www_hosts;
GRANT SELECT ON TABLE active_substance TO www_clients;


--
-- Name: active_substance_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE active_substance_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE active_substance_id_seq TO www_clients;


--
-- Name: drug; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE drug TO www_hosts;
GRANT SELECT ON TABLE drug TO www_clients;


--
-- Name: drug_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE drug_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE drug_id_seq TO www_clients;


--
-- Name: event; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE event TO www_hosts;
GRANT SELECT ON TABLE event TO www_clients;


--
-- Name: event_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE event_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE event_id_seq TO www_clients;


--
-- Name: event_result; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE event_result TO www_hosts;
GRANT SELECT ON TABLE event_result TO www_clients;


--
-- Name: event_result_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE event_result_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE event_result_id_seq TO www_clients;


--
-- Name: event_result_mapping; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE event_result_mapping TO www_hosts;
GRANT SELECT ON TABLE event_result_mapping TO www_clients;


--
-- Name: faers_user; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE faers_user TO www_hosts;
GRANT SELECT ON TABLE faers_user TO www_clients;


--
-- Name: faers_user_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE faers_user_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE faers_user_id_seq TO www_clients;


--
-- Name: meta; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE meta TO www_hosts;
GRANT SELECT ON TABLE meta TO www_clients;


--
-- Name: meta_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE meta_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE meta_id_seq TO www_clients;


--
-- Name: meta_results; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE meta_results TO www_hosts;
GRANT SELECT ON TABLE meta_results TO www_clients;


--
-- Name: meta_results_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE meta_results_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE meta_results_id_seq TO www_clients;


--
-- Name: openfda_drug_info; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info TO www_clients;


--
-- Name: openfda_drug_info_application_number; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_application_number TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_application_number TO www_clients;


--
-- Name: openfda_drug_info_brand_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_brand_name TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_brand_name TO www_clients;


--
-- Name: openfda_drug_info_generic_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_generic_name TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_generic_name TO www_clients;


--
-- Name: openfda_drug_info_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE openfda_drug_info_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE openfda_drug_info_id_seq TO www_clients;


--
-- Name: openfda_drug_info_manufacturer_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_manufacturer_name TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_manufacturer_name TO www_clients;


--
-- Name: openfda_drug_info_nui; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_nui TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_nui TO www_clients;


--
-- Name: openfda_drug_info_package_ndc; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_package_ndc TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_package_ndc TO www_clients;


--
-- Name: openfda_drug_info_pharm_class_cs; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_pharm_class_cs TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_pharm_class_cs TO www_clients;


--
-- Name: openfda_drug_info_pharm_class_epc; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_pharm_class_epc TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_pharm_class_epc TO www_clients;


--
-- Name: openfda_drug_info_pharm_class_moa; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_pharm_class_moa TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_pharm_class_moa TO www_clients;


--
-- Name: openfda_drug_info_pharm_class_pe; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_pharm_class_pe TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_pharm_class_pe TO www_clients;


--
-- Name: openfda_drug_info_product_ndc; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_product_ndc TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_product_ndc TO www_clients;


--
-- Name: openfda_drug_info_product_type; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_product_type TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_product_type TO www_clients;


--
-- Name: openfda_drug_info_route; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_route TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_route TO www_clients;


--
-- Name: openfda_drug_info_rxcui; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_rxcui TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_rxcui TO www_clients;


--
-- Name: openfda_drug_info_spl_id; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_spl_id TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_spl_id TO www_clients;


--
-- Name: openfda_drug_info_spl_set_id; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_spl_set_id TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_spl_set_id TO www_clients;


--
-- Name: openfda_drug_info_substance_name; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_substance_name TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_substance_name TO www_clients;


--
-- Name: openfda_drug_info_unii; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE openfda_drug_info_unii TO www_hosts;
GRANT SELECT ON TABLE openfda_drug_info_unii TO www_clients;


--
-- Name: patient; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient TO www_hosts;
GRANT SELECT ON TABLE patient TO www_clients;


--
-- Name: patient_death; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient_death TO www_hosts;
GRANT SELECT ON TABLE patient_death TO www_clients;


--
-- Name: patient_death_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE patient_death_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE patient_death_id_seq TO www_clients;


--
-- Name: patient_drug_mapping; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient_drug_mapping TO www_hosts;
GRANT SELECT ON TABLE patient_drug_mapping TO www_clients;


--
-- Name: patient_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE patient_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE patient_id_seq TO www_clients;


--
-- Name: patient_reaction_mapping; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE patient_reaction_mapping TO www_hosts;
GRANT SELECT ON TABLE patient_reaction_mapping TO www_clients;


--
-- Name: preferred_drug; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE preferred_drug TO www_hosts;
GRANT SELECT ON TABLE preferred_drug TO www_clients;


--
-- Name: primary_source; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE primary_source TO www_hosts;
GRANT SELECT ON TABLE primary_source TO www_clients;


--
-- Name: primary_source_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE primary_source_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE primary_source_id_seq TO www_clients;


--
-- Name: reaction; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE reaction TO www_hosts;
GRANT SELECT ON TABLE reaction TO www_clients;


--
-- Name: reaction_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE reaction_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE reaction_id_seq TO www_clients;


--
-- Name: receiver; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE receiver TO www_hosts;
GRANT SELECT ON TABLE receiver TO www_clients;


--
-- Name: receiver_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE receiver_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE receiver_id_seq TO www_clients;


--
-- Name: report_duplicate; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE report_duplicate TO www_hosts;
GRANT SELECT ON TABLE report_duplicate TO www_clients;


--
-- Name: report_duplicate_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE report_duplicate_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE report_duplicate_id_seq TO www_clients;


--
-- Name: sender; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON TABLE sender TO www_hosts;
GRANT SELECT ON TABLE sender TO www_clients;


--
-- Name: sender_id_seq; Type: ACL; Schema: faers; Owner: faers_data_admin
--

GRANT SELECT ON SEQUENCE sender_id_seq TO www_hosts;
GRANT SELECT ON SEQUENCE sender_id_seq TO www_clients;


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
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA faers GRANT SELECT ON TABLES  TO www_hosts;


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

