CREATE OR REPLACE FUNCTION fhir.export_training_data(
    resource_types fhir.resource_type[] DEFAULT NULL
)
RETURNS TABLE (
    resource_id uuid,
    resource_type fhir.resource_type,
    training_text text
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.id,
        r.resource_type,
        fhir.resource_to_text(r.data) as training_text
    FROM fhir.resource r
    WHERE (resource_types IS NULL OR r.resource_type = ANY(resource_types))
    AND r.status != 'entered-in-error';
END;
$$ LANGUAGE plpgsql;
