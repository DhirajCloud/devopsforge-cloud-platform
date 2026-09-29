# DevOpsForge — Cloud-Native DevOps Platform

A production-style cloud-native DevOps project demonstrating Infrastructure as Code, containerization, Kubernetes, CI/CD automation, DevSecOps, autoscaling, and observability on AWS.

---

## 🚀 Project Overview

**DevOpsForge** is an end-to-end DevOps platform built around a FastAPI application and deployed on Amazon EKS.

The project demonstrates how modern DevOps practices can be combined into a complete delivery pipeline:

```text
Developer
    |
    v
  GitHub
    |
    +----------------------+
    |                      |
    v                      v
   CI                    CD
    |                      |
    +--> Pytest            +--> GitHub OIDC
    +--> Docker Build             |
    +--> Trivy Scan               v
                            AWS IAM Role
                                  |
                                  v
                             Amazon ECR
                                  |
                                  v
                             Amazon EKS
                                  |
                   +--------------+--------------+
                   |              |              |
                   v              v              v
              Deployment         HPA        LoadBalancer
                   |
                   v
                FastAPI
                   
              Amazon EKS
                   |
             +-----+------+
             |            |
             v            v
         Prometheus    Grafana
```

---

## 🎯 Project Objectives

The project was designed to demonstrate a complete DevOps lifecycle:

* Provision AWS infrastructure using Terraform
* Build and containerize a FastAPI application
* Automate application testing
* Scan Docker images for vulnerabilities
* Store container images in Amazon ECR
* Deploy workloads to Amazon EKS
* Configure Kubernetes autoscaling
* Expose the application through an AWS LoadBalancer
* Monitor Kubernetes infrastructure with Prometheus
* Visualize metrics with Grafana
* Implement GitHub Actions CI/CD
* Authenticate GitHub Actions with AWS using OIDC
* Avoid long-lived AWS credentials in the CI/CD workflow

---

## 🛠️ Technology Stack

| Category               | Technology                        |
| ---------------------- | --------------------------------- |
| Application            | Python / FastAPI                  |
| Testing                | Pytest                            |
| Containerization       | Docker                            |
| Infrastructure as Code | Terraform                         |
| Cloud                  | AWS                               |
| Container Registry     | Amazon ECR                        |
| Kubernetes             | Amazon EKS                        |
| CI/CD                  | GitHub Actions                    |
| Cloud Authentication   | AWS IAM + GitHub OIDC             |
| Security               | Trivy                             |
| Autoscaling            | Kubernetes HPA                    |
| Monitoring             | Prometheus                        |
| Visualization          | Grafana                           |
| OS / CLI               | Linux / macOS / AWS CLI / kubectl |

---

# 🏗️ Architecture

## AWS Infrastructure

The platform is deployed in AWS `ap-south-1`.

The infrastructure includes:

* Amazon VPC
* Public subnets
* Private subnets
* NAT Gateway
* Amazon EKS
* EKS managed node group
* Kubernetes networking components
* IAM configuration
* Supporting AWS networking resources

Worker nodes are deployed in private subnets.

```text
                     AWS
                      |
                      v
                    VPC
                      |
             +--------+--------+
             |                 |
             v                 v
        Public Subnets    Private Subnets
             |                 |
             |                 v
             |             Amazon EKS
             |                 |
             |        +--------+--------+
             |        |                 |
             |        v                 v
             |    Worker Node 1    Worker Node 2
             |        |                 |
             |        +--------+--------+
             |                 |
             |                 v
             |          FastAPI Pods
             |
             v
         NAT Gateway
```

---

# 🐍 Application

The application is a lightweight FastAPI service.

The application source code is located under:

```text
app/
├── Dockerfile
├── pytest.ini
├── requirements.txt
├── src/
│   └── main.py
└── tests/
    └── test_health.py
```

## Health Endpoint

```http
GET /health
```

Expected response:

```json
{
  "status": "healthy",
  "service": "devopsforge-api"
}
```

The application listens on port:

```text
8000
```

---

# 🐳 Docker

The application is packaged using Docker.

The image uses:

```text
Python 3.12
```

Dockerfile:

```text
app/Dockerfile
```

Build the image:

```bash
docker build -f app/Dockerfile -t devopsforge-api:local app/
```

Run the container:

```bash
docker run --rm -p 8000:8000 devopsforge-api:local
```

Test the application:

```bash
curl http://localhost:8000/health
```

---

# ☁️ Infrastructure as Code

Terraform is used to provision and manage AWS infrastructure.

Project structure:

```text
terraform/
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── eks/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── .terraform.lock.hcl
```

The EKS configuration uses:

* Kubernetes `1.33`
* EKS managed node groups
* `t3.small` worker nodes
* Private worker-node subnets
* VPC CNI
* kube-proxy
* CoreDNS

Terraform resource tagging includes:

```text
Project
Environment
ManagedBy
```

## Terraform Commands

Initialize:

```bash
cd terraform
terraform init
```

Validate:

```bash
terraform validate
```

Review infrastructure changes:

```bash
terraform plan
```

Apply infrastructure:

```bash
terraform apply
```

---

# ☸️ Kubernetes

The application is deployed into the:

```text
devopsforge
```

namespace.

Kubernetes manifests:

```text
kubernetes/
├── namespace.yaml
├── deployment.yaml
├── service.yaml
└── hpa.yaml
```

The platform uses:

* Namespace
* Deployment
* Service
* Horizontal Pod Autoscaler

---

## Kubernetes Deployment

The application Deployment provides:

* Two application replicas
* Rolling updates
* CPU resource requests
* CPU resource limits
* Memory resource requests
* Memory resource limits
* Container image deployment from Amazon ECR

Current resource configuration:

```text
CPU request:    100m
CPU limit:      500m

Memory request: 128Mi
Memory limit:   512Mi
```

---

## LoadBalancer

The application is exposed through a Kubernetes `LoadBalancer` Service.

Traffic flow:

```text
Internet
   |
   v
AWS LoadBalancer
   |
   v
Kubernetes Service
   |
   v
FastAPI Pods
```

---

# 📈 Horizontal Pod Autoscaler

The application uses Kubernetes HPA to automatically adjust the number of replicas based on CPU utilization.

Configuration:

```text
Minimum replicas: 2
Maximum replicas: 5
CPU target:       50%
```

During final validation:

```text
CPU:              2% / 50%
Current replicas: 2
Minimum replicas: 2
Maximum replicas: 5
```

The HPA was successfully deployed and reported live CPU metrics through Kubernetes Metrics Server.

---

# 🔄 CI Pipeline

The CI workflow is located at:

```text
.github/workflows/ci.yaml
```

The workflow runs on:

* Pushes to `main`
* Pull requests targeting `main`

Pipeline:

```text
GitHub Push / Pull Request
          |
          v
      Checkout
          |
          v
      Python 3.12
          |
          v
   Install Dependencies
          |
          v
       Run Pytest
          |
          v
    Build Docker Image
          |
          v
     Trivy Security Scan
```

## CI Responsibilities

The CI pipeline verifies:

1. Application dependencies install correctly
2. Unit tests pass
3. Docker image builds successfully
4. Container image security scanning completes successfully

Trivy checks for:

```text
HIGH
CRITICAL
```

vulnerabilities while ignoring unfixed vulnerabilities.

---

# 🚀 CD Pipeline

The CD workflow is located at:

```text
.github/workflows/cd.yaml
```

It runs automatically when changes are pushed to `main`.

Pipeline:

```text
GitHub Push
     |
     v
GitHub Actions
     |
     v
GitHub OIDC
     |
     v
AWS IAM Role
     |
     v
Amazon ECR Login
     |
     v
Docker Build
     |
     v
Push Image to ECR
     |
     v
Configure kubectl
     |
     v
Deploy Image to EKS
     |
     v
Wait for Rollout
     |
     v
Verify Deployment
```

The deployment process updates the Kubernetes Deployment with the newly built image tagged using the Git commit SHA.

---

# 🔐 GitHub OIDC Authentication

GitHub Actions authenticates to AWS using:

```text
GitHub Actions
       |
       v
OIDC Identity Token
       |
       v
AWS STS
       |
       v
IAM Role
       |
       v
AWS Resources
```

This approach avoids storing long-lived AWS access keys in GitHub Actions.

The IAM trust policy restricts access to the intended GitHub repository and deployment branch.

---

# 🛡️ DevSecOps

Security is integrated into the delivery pipeline rather than being treated as a separate final step.

Security practices include:

* GitHub Actions OIDC authentication
* No long-lived AWS credentials in CI/CD
* Trivy container vulnerability scanning
* IAM-based AWS access
* Private EKS worker-node subnets
* Kubernetes resource limits
* Container image validation before deployment
* Sensitive local IAM policy files excluded from Git

---

# 📊 Monitoring & Observability

The Kubernetes environment uses the Prometheus monitoring stack.

Components deployed include:

```text
Prometheus
Grafana
Alertmanager
Node Exporter
kube-state-metrics
Prometheus Operator
```

Monitoring architecture:

```text
                 Amazon EKS
                     |
        +------------+------------+
        |                         |
        v                         v
   Kubernetes                 Application
    Metrics                    Metrics
        |                         |
        +------------+------------+
                     |
                     v
                Prometheus
                     |
                     v
                  Grafana
```

Grafana dashboards provide visibility into:

* Cluster resources
* Node resources
* Pod resources
* Kubernetes workloads
* Namespace resources
* Kubernetes components
* Node metrics
* Application infrastructure

Prometheus was successfully accessed through Kubernetes port forwarding and Grafana was successfully accessed with Kubernetes dashboards.

---

# 🧪 Validation

The platform was validated end-to-end.

## Application

```text
Health endpoint: PASS
HTTP status:     200
Application:     healthy
```

## Kubernetes

```text
Deployment:      2/2 Ready
Application pods: Running
```

## HPA

```text
CPU:              2% / 50%
Minimum replicas: 2
Maximum replicas: 5
Current replicas: 2
```

## CI/CD

Final validation was performed against commit:

```text
aff3ea2
```

GitHub Actions:

```text
DevOpsForge CI #10  -> SUCCESS
DevOpsForge CD #10  -> SUCCESS
```

### CI successfully validated

```text
✓ Python tests
✓ Docker build
✓ Trivy vulnerability scan
```

### CD successfully validated

```text
✓ GitHub OIDC authentication
✓ AWS authentication
✓ ECR login
✓ Docker image build
✓ ECR image push
✓ EKS deployment
✓ Kubernetes rollout
✓ Deployment verification
```

---

# 📁 Repository Structure

```text
devopsforge-cloud-platform/
│
├── .github/
│   └── workflows/
│       ├── ci.yaml
│       └── cd.yaml
│
├── app/
│   ├── Dockerfile
│   ├── pytest.ini
│   ├── requirements.txt
│   ├── src/
│   │   └── main.py
│   └── tests/
│       └── test_health.py
│
├── kubernetes/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── hpa.yaml
│
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── eks/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── .terraform.lock.hcl
│
├── .gitignore
├── LICENSE
└── README.md
```

---

# 💻 Local Development

Create a Python virtual environment:

```bash
cd app
python3 -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Run tests:

```bash
pytest -v
```

Start the application:

```bash
uvicorn src.main:app --host 0.0.0.0 --port 8000
```

Test:

```bash
curl http://localhost:8000/health
```

---

# ☸️ EKS Access

Configure `kubectl`:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name devopsforge-dev-eks
```

Check worker nodes:

```bash
kubectl get nodes
```

Check application:

```bash
kubectl get deployment -n devopsforge
kubectl get pods -n devopsforge
kubectl get hpa -n devopsforge
kubectl get svc -n devopsforge
```

Check resource utilization:

```bash
kubectl top nodes
kubectl top pods -n devopsforge
```

---

# 📊 Monitoring Access

## Prometheus

```bash
kubectl port-forward \
  -n monitoring \
  svc/kube-prometheus-stack-prometheus \
  9090:9090
```

Open:

```text
http://localhost:9090
```

## Grafana

```bash
kubectl port-forward \
  -n monitoring \
  svc/kube-prometheus-stack-grafana \
  3000:80
```

Open:

```text
http://localhost:3000
```

---

# 🔮 Future Improvements

Potential future enhancements include:

* HTTPS/TLS
* Route 53 DNS
* AWS Load Balancer Controller
* AWS Secrets Manager integration
* Centralized logging
* Alertmanager notification integrations
* GitOps with Argo CD
* Blue/Green deployments
* Canary deployments
* Separate staging and production environments
* Application performance monitoring
* Distributed tracing

---

# 👨‍💻 Author

**Dhiraj Dwivedi**

DevOps / Cloud Engineer

GitHub: **DhirajCloud**

Repository: **devopsforge-cloud-platform**

---

## 📌 Project Summary

DevOpsForge demonstrates hands-on implementation of:

```text
AWS
+
Terraform
+
Docker
+
Kubernetes
+
Amazon EKS
+
Amazon ECR
+
GitHub Actions
+
OIDC
+
Trivy
+
HPA
+
Prometheus
+
Grafana
+
FastAPI
```

The project brings infrastructure provisioning, application delivery, security, deployment automation, autoscaling, and observability together into a single end-to-end DevOps platform.
