module "s3" {
  source = "./infra/modules/s3"
}

module "iam" {
  source = "./infra/modules/iam"
}


module "codebuild" {
  source = "./infra/modules/codebuild"
  codebuild_role_arn = module.iam.codebuild_role_arn
}


module "codedeploy" {
  source = "./infra/modules/codedeploy"
}

module "codepipeline" {
  source = "./infra/modules/codepipeline"

  github_token     = var.github_token
  artifact_bucket  = module.s3.bucket_name
  build_project_id = module.codebuild.project_id
  codedeploy_app   = module.codedeploy.app_name
  codedeploy_group = module.codedeploy.group_name
}
