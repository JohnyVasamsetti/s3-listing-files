# README: S3 Bucket Content Listing Service and Terraform Setup

## Overview

This project implements an HTTP service that exposes an endpoint to list the contents of an S3 bucket. The service is deployed on an EC2 instance and configured to be accessible via a static IP. Additionally, Terraform scripts are provided to provision the required infrastructure on AWS, including the EC2 instance, IAM roles, security groups, and networking configurations.

## Part 1: HTTP Service

### Features

- **Endpoint**: `GET http://<IP>:5000/list-bucket-contents/<path>`
  - Returns the contents of the specified S3 bucket path in JSON format.
  - If no path is specified, the top-level contents are returned.

### Example Responses

1. **Request**: `http://<IP>:5000/list-bucket-contents`
   **Response**: `{ "content": ["dir1", "dir2"] }`
2. **Request**: `http://<IP>:5000/list-bucket-contents/dir1`
   **Response**: `{ "content": [] }`
3. **Request**: `http://<IP>:5000/list-bucket-contents/dir2`
   **Response**: `{ "content": ["file1", "file2"] }`

### Service Setup

1. **Requirements**:

   - Python 3.x
   - Boto3 library
   - Flask library

2. **Service Code**:
   The service is implemented in Python using Flask and Boto3. It fetches S3 bucket contents using the instance profile role attached to the EC2 instance.

3. **Running the Service**:
   ```bash
   python3 app.py
   ```

## Part 2: Terraform Infrastructure

### Terraform Features

- Create state bucket to store terraform state.
- Provisions the networking components required.
- Provisions an EC2 instance with a static Elastic IP.
- Configures an IAM role with permissions to access the S3 bucket.
- Create an empty S3 bucket
- Sets up security groups to allow HTTP traffic on port 5000.
- Deploys the Python service as part of the EC2 instance's user data.

### How to Run the Terraform Scripts

#### Prerequisites

- Install [Terraform](https://www.terraform.io/downloads.html).
- Configure AWS credentials.

#### Steps

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/JohnyVasamsetti/s3-listing-files
   cd s3-listing-files
   ```

2. **Initialize Terraform**:

   ```bash
   terraform init
   ```

3. **Plan the Infrastructure**:

   ```bash
   terraform plan
   ```

4. **Apply the Configuration**:

   ```bash
   terraform apply
   ```

5. **Retrieve the Public IP**:
   After the apply step, note the public IP of the EC2 instance from the output.

6. **Upload files to S3 bucket**:
   After you provision everything, create folder with temporary files and upload the files to s3 bucket using aws-cli from local machine.

   ```bash
   aws s3 cp files-to-upload s3://content-storage-for-listing-assignment --recursive
   ```

7. **Access the Service**:
   Use the public IP to access the endpoint:
   ```bash
   curl http://<public-ip>:5000/list-bucket-contents
   ```

### Cleanup

To delete all resources created by Terraform:

```bash
terraform destroy
```

<br><br>

# Login to instance for troubleshooting

#### Steps

1. **Modify Security Group**:
   Uncomment the following lines in the networking.tf file:

   ```hcl
   ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }
   ```

2. **Apply Terraform Changes**:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Retrieve the Private Key**:
   Use AWS CLI to retrieve the private key from Secrets Manager and save it as a .pem file:

   ```bash
   aws secretsmanager get-secret-value --secret-id <your-secret-id> --query 'SecretString' --output text > private-key.pem
   ```

4. **Set Permissions on the Key**

   ```bash
   chmod 400 private-key.pem
   ```

5. **Connect to the EC2 Instance**
   ```bash
   ssh -i private-key.pem ec2-user@<public-ip>
   ```
