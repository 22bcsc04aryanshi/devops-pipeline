resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

# ───────────────────────────────────────

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

# ───────────────────────────────────────

resource "aws_iam_role" "codedeploy_role" {
  name = "codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_role_policy" "codepipeline_codestar_policy" {
  name = "CodePipelineCodeStarPolicy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codestar-connections:UseConnection"
        ],
        Resource = "arn:aws:codeconnections:ap-south-1:660380598349:connection/730bc345-06cc-42ae-a9ec-8c8a9aae0124"
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds"
        ],
        Resource = "arn:aws:codebuild:ap-south-1:660380598349:project/my-build-project"
      }
    ]
  })
}


resource "aws_iam_role_policy" "codepipeline_s3_access" {
  name = "CodePipelineS3Access"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.artifact_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.artifact_bucket}"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy" "codebuild_logs_policy" {
  name = "CodeBuildCloudWatchLogsPolicy"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:ap-south-1:660380598349:log-group:/aws/codebuild/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_s3_access" {
  name = "CodeBuildS3Access"
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject" 
        ],
        Resource = "arn:aws:s3:::${var.artifact_bucket}/*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = "arn:aws:s3:::${var.artifact_bucket}"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_codedeploy_policy" {
  name = "CodePipelineCodeDeployPolicy"
  role = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment",
          "codedeploy:RegisterApplicationRevision",
          "codedeploy:GetDeploymentConfig"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codedeploy_permissions" {
  name = "CodeDeployEC2S3Access"
  role = aws_iam_role.codedeploy_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Resource = [
          "arn:aws:s3:::${var.artifact_bucket}",
          "arn:aws:s3:::${var.artifact_bucket}/*"
        ]
      }
    ]
  })
}
