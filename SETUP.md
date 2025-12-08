# HNG Stage 6 - Complete Setup Instructions

## Prerequisites Checklist

- [ ] AWS Account with appropriate permissions
- [ ] Domain name (can use a free subdomain from services like freenom.com)
- [ ] SSH key pair generated
- [ ] S3 bucket created for Terraform state
- [ ] GitHub repository forked and cloned

## Step 1: AWS Setup

1. **Create S3 Bucket for Terraform State:**
   ```bash
   aws s3 mb s3://your-terraform-state-bucket-unique-name
   ```

2. **Generate SSH Key Pair:**
   ```bash
   ssh-keygen -t ed25519 -b 4096 -f ~/.ssh/
   ```

## Step 2: Configure Terraform

1. **Update S3 Backend in `infra/terraform/main.tf`:**
   ```hcl
   backend "s3" {
     bucket = "your-terraform-state-bucket-unique-name"
     key    = "hng-stage6/terraform.tfstate"
     region = "us-east-1"
   }
   ```

2. **Create `infra/terraform/terraform.tfvars`:**
   ```hcl
    aws_region              = "us-east-1" 
    ec2_key                 = "~/.ssh/id_rsa.pub"  #path to your public ssh key
    projectname             = "epicbook"
    ami                     = "ami-0bbdd8c17ed981ef9" 
    domain                  = "baghira.chickenkiller.com"
    ssh_private_key_path    = "~/.ssh/id_rsa"          #path to your private ssh key
   ```

## Step 3: GitHub Secrets Configuration

Add these secrets to your GitHub repository:

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `PUBLIC_KEY`: Content of your public SSH key
- `PRIVATE_KEY`: Content of your private SSH key
- `PRIVATE_KEY_PATH`: Path to private key (e.g., ~/.ssh/hng-stage6)
- `DOMAIN_NAME`: Your domain name
- `EMAIL`: Your email for Let's Encrypt
- `SERVER_IP`: Will be set after first deployment
- `SMTP_USERNAME`: Gmail address for notifications
- `SMTP_PASSWORD`: Gmail app password
- `NOTIFICATION_EMAIL`: Email to receive drift alerts

## Step 4: Domain Configuration

Point your domain's A record to your server's IP address (you'll get this after deployment).

## Step 5: Deploy Infrastructure

1. **Local Deployment:**
   ```bash
   cd infra
   chmod +x ci_deploy.sh
   ./ci_deploy.sh
   ```

2. **Or via GitHub Actions:**
   - Push changes to trigger the workflow
   - Monitor the Actions tab for deployment progress

## Step 6: Verify Deployment

1. **Check Services:**
   ```bash
   ssh -i ~/.ssh/id_rsa ubuntu@your-server-ip
   docker-compose ps
   ```

2. **Test Endpoints:**
   - https://your-domain.com (should show login page)
   - https://your-domain.com/api/auth (should return "Not Found")
   - https://your-domain.com/api/todos (should return "Invalid Token")
   - https://your-domain.com/api/users (should return "Missing Authorization")

## Step 7: Screenshots for Submission

Take screenshots of:
1. Login page on your domain
2. TODO dashboard after login
3. Successful Terraform apply output
4. Terraform "No changes" output (run terraform plan again)
5. Drift detection email alert (modify infrastructure to trigger)
6. Ansible deployment output

## Troubleshooting

### Common Issues:

1. **Terraform State Lock:**
   ```bash
   terraform force-unlock LOCK_ID
   ```

2. **SSH Connection Refused:**
   - Check security group allows SSH from your IP
   - Verify SSH key permissions: `chmod 600 ~/.ssh/id_rsa`

3. **SSL Certificate Issues:**
   - Ensure domain points to server IP
   - Check Let's Encrypt rate limits
   - Verify port 80 is accessible for HTTP challenge

4. **Services Not Starting:**
   ```bash
   docker-compose logs [service-name]
   docker system prune -f
   docker-compose up -d --build
   ```

## Testing Drift Detection

1. **Modify Infrastructure:**
   ```bash
   # Add a tag to EC2 instance in main.tf, under local block
   tags = {
    env      = local.environment
    location = var.aws_region
  }
   }
   ```

2. **Commit and Push:**
   ```bash
   git add .
   git commit -m "Test drift detection"
   git push origin main
   ```

3. **Check Email:** You should receive a drift detection alert

## Final Checklist

- [ ] Infrastructure deployed successfully
- [ ] All services running and accessible
- [ ] SSL certificates working
- [ ] CI/CD pipeline configured
- [ ] Drift detection tested
- [ ] Screenshots taken
- [ ] Presentation prepared

## Submission Requirements

1. **Repository URL:** Your GitHub repository link
2. **Frontend URL:** https://your-domain.com
3. **Screenshots:** All required screenshots
4. **Presentation:** Prepared slides for interview