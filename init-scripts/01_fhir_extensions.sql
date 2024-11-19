-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "plv8";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- Create FHIR schema
CREATE SCHEMA IF NOT EXISTS fhir;

-- Create custom types for FHIR resources
CREATE TYPE fhir.resource_type AS ENUM (
    'Patient',
    'Observation',
    'Condition',
    'Procedure',
    'MedicationRequest',
    'DiagnosticReport'
);

-- Create base FHIR resource table
CREATE TABLE fhir.resource (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    resource_type fhir.resource_type NOT NULL,
    status varchar(64),
    version_id integer NOT NULL DEFAULT 1,
    last_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    data jsonb NOT NULL,
    text_vector tsvector
);
