module "s3" {
  source = "./infra/modules/s3"
}

module "iam" {
  source = "./infra/modules/iam"
}

module "ec2" {
  source          = "./infra/modules/ec2"
  ami_id          = "ami-0d0ad8bb301edb745"  # Example Amazon Linux 2 AMI (update for your region)
  instance_type   = "t2.micro"
  key_name        = "my-keypair"     # You must create this in AWS EC2 > Key Pairs
  subnet_id       = "subnet-0d6b45113ae5f1053"       # Get from your VPC/Subnet
  security_group  = "sg-0f5f8b48d25d35f02"           # Your SG that allows SSH/HTTP
}


module "codebuild" {
  source = "./infra/modules/codebuild"
  codebuild_role_arn = module.iam.codebuild_role_arn
}

module "codedeploy" {
  source = "./infra/modules/codedeploy"
  codedeploy_role_arn = module.iam.codedeploy_role_arn
}


module "codepipeline" {
  source = "./infra/modules/codepipeline"

  github_token         = var.github_token
  github_owner         = "22bcsc04aryanshi"                # Your GitHub username
  github_repo          = "devops-pipeline"                 # Your GitHub repo name
  artifact_bucket      = module.s3.bucket_name
  build_project_id     = module.codebuild.project_id
  codedeploy_app       = module.codedeploy.app_name
  codedeploy_group     = module.codedeploy.group_name
  codepipeline_role_arn = module.iam.codepipeline_role_arn
}

