module "s3" {
  source = "./infra/modules/s3"
}

module "iam" {
  source = "./infra/modules/iam"
  artifact_bucket = module.s3.bucket_name
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
  source                   = "./infra/modules/codepipeline"

  codepipeline_role_arn    = module.iam.codepipeline_role_arn
  github_owner             = "22bcsc04aryanshi"
  github_repo              = "devops-pipeline"
  artifact_bucket          = module.s3.bucket_name
  build_project_id         = module.codebuild.project_id
  codedeploy_app           = module.codedeploy.app_name
  codedeploy_group         = module.codedeploy.group_name

  codestar_connection_arn  = "arn:aws:codeconnections:ap-south-1:660380598349:connection/730bc345-06cc-42ae-a9ec-8c8a9aae0124"
}



