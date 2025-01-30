resource "aws_iam_role" "github_actions_role" {
  name = "MyGitHubActionsRole"
  description = "Crear rol de Github en AWS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::2481899437:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:gruposdosdual/cloud-resources1:ref:refs/heads/dev"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "github_ecr_policy" {
  name        = "GitHubActionsECRPolicy"
  description = "Permisos mínimos para que GitHub Actions trabaje con AWS ECR"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "github_ecr_policy_attachment" {
  name       = "GitHubActionsECRPolicyAttachment"
  policy_arn = aws_iam_policy.github_ecr_policy.arn
  roles      = [aws_iam_role.github_actions_role.name]
}

resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"]  # Thumbprint actual
}

/*
resource "aws_iam_role_policy_attachment" "github_actions_role_policy_attachment" {
    role       = aws_iam_role.github_actions_role.id
    policy_arn = aws_iam_policy.github_ecr_policy.arn
}

*/