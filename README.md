# 🚀 DevOps + DevSecOps CI/CD Pipeline

This project sets up a complete CI/CD pipeline with AWS (CodePipeline, CodeBuild, CodeDeploy) and integrates security scanning using GitHub Actions with tfsec, Trivy, and Sealed Secrets.

---

## 🔧 Task 1: DevOps Pipeline (AWS)

- **Tools:** Terraform, CodePipeline, CodeBuild, CodeDeploy, EC2, S3
- **Flow:**
  1. Code pushed to GitHub triggers CodePipeline
  2. CodeBuild zips `deploy/` folder → uploads to S3
  3. CodeDeploy deploys to EC2 using `appspec.yml` + lifecycle scripts

**Key Files:**
- `appspec.yml`: Defines EC2 deployment hooks
- `buildspec.yml`: Zips deploy directory
- Shell scripts: `install.sh`, `start.sh`, `stop.sh`

---

## 🛡️ Task 2: DevSecOps Integration

- **Tools:** GitHub Actions, tfsec, Trivy, Sealed Secrets
- **Workflow:** `.github/workflows/devsecops.yml`
  - Scans Terraform code (tfsec)
  - Scans Dockerfile & files (Trivy)
  - Can add sealed secrets for Kubernetes

---

# How to Run?

terraform init && terraform apply       # Task 1 Infra
git push origin main                    # Triggers pipeline + DevSecOps

