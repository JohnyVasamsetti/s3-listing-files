from flask import Flask, jsonify, request
import boto3
import os

app = Flask(__name__)

# AWS S3 Client
s3_client = boto3.client('s3',region_name='us-east-1')

BUCKET_NAME = 'content-storage-for-listing-assignment'

@app.route('/list-bucket-content', defaults={'path': ''}, methods=['GET'])
@app.route('/list-bucket-content/<path:path>', methods=['GET'])
def list_bucket_content(path):
    try:
        # Fetch objects from S3 bucket
        response = s3_client.list_objects_v2(Bucket=BUCKET_NAME, Prefix=path, Delimiter='/')
        print(response)
        # Directories
        dirs = [prefix['Prefix'].rstrip('/') for prefix in response.get('CommonPrefixes', [])]

        # Files
        files = [content['Key'] for content in response.get('Contents', []) if content['Key'] != path]

        return jsonify({'content': dirs + files})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
