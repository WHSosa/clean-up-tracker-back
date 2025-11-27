-- 01_types.sql
-- PostgreSQL enums and optional extensions

-- Optional: enable PostGIS if you plan to store precise coordinates
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- Event status values
CREATE TYPE event_status AS ENUM ('Planned', 'Ongoing', 'Completed', 'Cancelled');

-- Document type values
CREATE TYPE document_type AS ENUM ('Report', 'Map', 'Photo');
