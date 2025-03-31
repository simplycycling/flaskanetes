# Flaskanetes

A Flask application deployed on Amazon EKS (Elastic Kubernetes Service) with automated CI/CD using GitHub Actions.

## Architecture

### Infrastructure Components

- **EKS Cluster**: Kubernetes cluster running on AWS

  - Node Group: 2 t3.medium instances for running workloads
  - VPC with public and private subnets
  - NAT Gateway for outbound traffic from private subnets

- **Load Balancer**: AWS Application Load Balancer (ALB)

  - Managed by AWS Load Balancer Controller
  - Handles HTTPS termination
  - Routes traffic to Kubernetes pods

- **Container Registry**: Amazon ECR

  - Stores Docker images for the application
  - Integrated with GitHub Actions for automated builds

- **DNS & SSL**:
  - Route53 for DNS management
  - AWS Certificate Manager (ACM) for SSL certificates
  - Domain: flaskanetes.overengineering.cloud

### Kubernetes Resources

- **Deployment**: Manages the Flask application pods
- **Service**: Exposes the application internally
- **Ingress**: Routes external traffic to the application
- **ConfigMap**: Stores application configuration
- **ServiceAccount**: Manages AWS Load Balancer Controller permissions

## Prerequisites

- AWS Account with appropriate permissions
- AWS CLI configured
- kubectl installed
- Terraform installed
- Docker installed
- GitHub account with repository access

## Local Development

1. Clone the repository:

   ```bash
   git clone https://github.com/simplycycling/flaskanetes.git
   cd flaskanetes
   ```

2. Create and activate a virtual environment:

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

4. Run the application locally:
   ```bash
   python app.py
   ```

## Infrastructure Setup

The infrastructure is managed using Terraform and is organized into modules:

```
terraform/
├── environments/
│   └── dev/
│       └── main.tf
└── modules/
    ├── acm/
    ├── ecr/
    ├── eks/
    ├── iam/
    ├── route53/
    └── vpc/
```

### Deployment Process

1. **Infrastructure Deployment**:

   ```bash
   cd terraform/environments/dev
   terraform init
   terraform apply
   ```

2. **Kubernetes Configuration**:

   ```bash
   kubectl apply -f k8s/
   ```

3. **Application Deployment**:
   - Push changes to main branch
   - GitHub Actions will:
     - Build Docker image
     - Push to ECR
     - Deploy to EKS

## CI/CD Pipeline

The GitHub Actions workflow (`terraform.yml`) handles:

- Infrastructure deployment
- Docker image building
- ECR image pushing
- Kubernetes deployment

### Manual Infrastructure Cleanup

To destroy the infrastructure:

1. Go to GitHub Actions
2. Select "Terraform Destroy" workflow
3. Choose environment (dev/prod)
4. Run workflow

## Security

- HTTPS enforced through ALB
- Private subnets for worker nodes
- IAM roles with least privilege
- OIDC provider for GitHub Actions
- Network policies and security groups

## Monitoring

- AWS CloudWatch for infrastructure metrics
- Kubernetes metrics through EKS
- Application logs through kubectl

## Cost Management

Estimated monthly costs:

- EKS Control Plane: ~$72
- Worker Nodes (2x t3.medium): ~$60
- ALB: ~$16
- NAT Gateway: ~$32
- Other (ECR, Route53): Minimal

Total: ~$180-200 USD/month

## Troubleshooting

1. **Application Access Issues**:

   - Check ALB status: `kubectl get ingress`
   - Verify DNS resolution: `dig flaskanetes.overengineering.cloud`
   - Check SSL certificate: `kubectl get certificate`

2. **Infrastructure Issues**:
   - Check EKS cluster status: `aws eks describe-cluster --name flaskanetes-dev`
   - Verify VPC configuration: `aws ec2 describe-vpcs`
   - Check IAM roles: `aws iam get-role --role-name flaskanetes-dev-eks-cluster-role`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## TODO

### High Priority

- [ ] Add comprehensive test suite for the Flask application
- [ ] Implement proper logging and monitoring
- [ ] Add health check endpoints

### Infrastructure

- [ ] Add AWS CloudWatch integration for monitoring
- [ ] Set up AWS Backup for EKS cluster
- [ ] Implement auto-scaling policies
- [ ] Add AWS WAF for additional security

### Development

- [ ] Add pre-commit hooks for code quality
- [ ] Implement automated dependency updates
- [ ] Add API documentation using OpenAPI/Swagger
- [ ] Set up automated performance testing
- [ ] Add development environment setup script

### Security

- [ ] Implement secrets management using AWS Secrets Manager
- [ ] Add network policies for pod-to-pod communication
- [ ] Set up regular security scanning
- [ ] Implement pod security policies
- [ ] Add AWS GuardDuty integration

### Documentation

- [ ] Add detailed API documentation
- [ ] Create architecture diagrams
- [ ] Document deployment procedures
- [ ] Add troubleshooting guide
- [ ] Create runbook for common operations

### Cost Optimization

- [ ] Implement resource quotas
- [ ] Set up cost allocation tags
- [ ] Add AWS Cost Explorer integration
- [ ] Implement auto-scaling based on cost metrics
- [ ] Set up budget alerts
