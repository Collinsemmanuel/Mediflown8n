-- Create GIN index for full-text search
CREATE INDEX idx_resource_text_vector ON fhir.resource USING gin(text_vector);

-- Create index for resource type queries
CREATE INDEX idx_resource_type ON fhir.resource(resource_type);

-- Create index for JSON content
CREATE INDEX idx_resource_data ON fhir.resource USING gin(data jsonb_path_ops); 