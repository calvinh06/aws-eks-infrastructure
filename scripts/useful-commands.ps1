# Install Terraform
choco install terraform -y

# Create local configuration from safe examples
Copy-Item terraform.tfvars.example terraform.tfvars
Copy-Item backend.tf.example backend.tf
Copy-Item backend.hcl.example backend.hcl

# Back up local Terraform state before migration
Copy-Item terraform.tfstate "$env:USERPROFILE\terraform-bootstrap-state-backup.tfstate"

# Initialize or reconfigure an S3 backend
terraform init -reconfigure "-backend-config=backend.hcl"

# Migrate existing local state to S3
terraform init -migrate-state "-backend-config=backend.hcl"

# Format the entire Terraform repository
terraform fmt -recursive

# Create a saved plan
terraform plan -out=vpc.tfplan

# Produce a reviewable text plan
terraform show -no-color vpc.tfplan |
    Out-File -Encoding utf8 vpc-plan.txt

# Apply exactly the reviewed plan
terraform apply vpc.tfplan

# Inspect outputs and managed resources
terraform output
terraform state list

# Find the current public IP
(Invoke-RestMethod -Uri "https://checkip.amazonaws.com").Trim()

# Configure kubectl for EKS
aws eks update-kubeconfig `
    --region us-east-2 `
    --name transaction-exchange-dev

# Verify the cluster
kubectl get nodes
kubectl get nodes -L topology.kubernetes.io/zone
kubectl get pods -A

# Git review and commit
git status --short --ignored --untracked-files=all
git add .
git commit -m "Add Terraform infrastructure"
git push -u origin main

# Clone the application repository
git clone https://github.com/calvinh06/transaction-exchange-service.git

# Build and test the application
mvn clean verify
mvn clean package

# Build and run the Docker image
docker build -t transaction-exchange-service:0.0.1-SNAPSHOT .
docker run --rm -p 8080:8080 transaction-exchange-service:0.0.1-SNAPSHOT

# Test application readiness
Invoke-RestMethod http://localhost:8080/actuator/health/readiness

# Initialize the ECR stack from the repository root
terraform "-chdir=infrastructure/environments/dev/ecr" init `
    "-backend-config=backend.hcl"