resource "aws_codepipeline" "app_pipeline" {
  name     = "devops-pipeline"
  role_arn = var.codepipeline_role_arn
  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }

  stage {
  name = "Source"

  action {
    name             = "Source"
    category         = "Source"
    owner            = "AWS"
    provider         = "CodeStarSourceConnection"
    version          = "1"
    output_artifacts = ["source_output"]

    configuration = {
      ConnectionArn = var.codestar_connection_arn
      FullRepositoryId = "${var.github_owner}/${var.github_repo}"
      BranchName = "main"
    }
  }
}


  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.build_project_id
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      input_artifacts  = ["build_output"]
      version          = "1"

      configuration = {
        ApplicationName     = var.codedeploy_app
        DeploymentGroupName = var.codedeploy_group
      }
    }
  }
}
