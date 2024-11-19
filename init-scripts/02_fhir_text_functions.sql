CREATE OR REPLACE FUNCTION fhir.resource_to_text(resource_data jsonb)
RETURNS text
LANGUAGE plv8
AS $$
function processValue(key, value) {
    if (typeof value === 'object' && value !== null) {
        if (Array.isArray(value)) {
            return value.map(v => processValue(key, v)).join(' ');
        }
        if (value.text) return value.text;
        if (value.value) return `${key}: ${value.value}`;
        return Object.entries(value)
            .map(([k, v]) => processValue(k, v))
            .join(' ');
    }
    return `${key}: ${value}`;
}

const text = Object.entries(resource_data)
    .map(([key, value]) => processValue(key, value))
    .join('\n');

return text;
$$;

-- Create function to update text vectors
CREATE OR REPLACE FUNCTION fhir.update_text_vector()
RETURNS trigger AS $$
BEGIN
    NEW.text_vector = to_tsvector('english', fhir.resource_to_text(NEW.data));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for automatic text vector updates
CREATE TRIGGER update_resource_text_vector
    BEFORE INSERT OR UPDATE ON fhir.resource
    FOR EACH ROW
    EXECUTE FUNCTION fhir.update_text_vector();
