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

### 🔒 Tools Used:
- **tfsec**: Scans Terraform code for security vulnerabilities.
- **Trivy**: Scans the filesystem and Dockerfile for vulnerabilities.
- **Sealed Secrets**: Securely manages Kubernetes secrets in version control.
- **GitHub Actions**: Automates security scanning on push and PRs.

### ✅ GitHub Workflow (`.github/workflows/devsecops.yml`)
- Triggered on `push` or `pull_request` to the `main` branch.
- Runs `tfsec` on Terraform code.
- Installs and runs `Trivy` to scan Dockerfile and local files.
- You can extend this to include `kubesec` or `kube-score` later.




