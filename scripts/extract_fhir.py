import psycopg2
import json
from datetime import datetime

def extract_fhir_data(resource_type='Patient'):
    conn = psycopg2.connect(
        dbname="your_db_name",
        user="your_user",
        password="your_password",
        host="localhost"
    )
    
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT resource_id, resource_type, training_text 
                FROM fhir.export_training_data(ARRAY[%s]::fhir.resource_type[]);
            """, (resource_type,))
            
            # Create output file
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            output_file = f'fhir_data_{resource_type.lower()}_{timestamp}.jsonl'
            
            with open(output_file, 'w') as f:
                for row in cur:
                    record = {
                        'id': str(row[0]),
                        'type': row[1],
                        'text': row[2]
                    }
                    f.write(json.dumps(record) + '\n')
                    
            print(f"Data extracted to {output_file}")
            
    finally:
        conn.close()

if __name__ == "__main__":
    extract_fhir_data() 