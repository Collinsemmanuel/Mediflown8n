#!/bin/bash

# Get container ID
POSTGRES_CONTAINER=$(docker ps -qf "name=postgres")

# Execute query and save to file
docker exec $POSTGRES_CONTAINER psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\COPY (
    SELECT json_build_object(
        'id', resource_id,
        'type', resource_type,
        'text', training_text
    )::text 
    FROM fhir.export_training_data(ARRAY['Patient']::fhir.resource_type[])
) TO STDOUT" > fhir_extract_$(date +%Y%m%d_%H%M%S).jsonl 