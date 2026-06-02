# ⚠️ SOLO PARA LABORATORIO CONTROLADO

# ── Policy para dev-user ───────────────────────────────────
resource "aws_iam_policy" "dev_policy" {
  name        = "${var.lab_prefix}-dev-policy"
  description = "Policy vulnerable - lab only"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "S3Access"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = "*"
      },
      {
        Sid    = "IAMPrivesc"
        Effect = "Allow"
        Action = [
          "iam:CreatePolicyVersion",
          "iam:ListPolicies",
          "iam:GetPolicy",
          "iam:GetPolicyVersion"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "dev_user" {
  name = "${var.lab_prefix}-dev-user"
  tags = { Lab = "misconfig" }
}

resource "aws_iam_user_policy_attachment" "dev_user" {
  user       = aws_iam_user.dev_user.name
  policy_arn = aws_iam_policy.dev_policy.arn
}

resource "aws_iam_access_key" "dev_user" {
  user = aws_iam_user.dev_user.name
}

# ── Policy para ci-deploy ──────────────────────────────────
resource "aws_iam_policy" "ci_policy" {
  name        = "${var.lab_prefix}-ci-policy"
  description = "Policy CI vulnerable - lab only"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LambdaAccess"
        Effect = "Allow"
        Action = [
          "lambda:CreateFunction",
          "lambda:InvokeFunction",
          "lambda:UpdateFunctionCode",
          "lambda:GetFunction"
        ]
        Resource = "*"
      },
      {
        Sid      = "PassRole"
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "ci_deploy" {
  name = "${var.lab_prefix}-ci-deploy"
  tags = { Lab = "misconfig" }
}

resource "aws_iam_user_policy_attachment" "ci_deploy" {
  user       = aws_iam_user.ci_deploy.name
  policy_arn = aws_iam_policy.ci_policy.arn
}

resource "aws_iam_access_key" "ci_deploy" {
  user = aws_iam_user.ci_deploy.name
}

# ── Rol: ec2-instance-role ─────────────────────────────────
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.lab_prefix}-ec2-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = { Lab = "misconfig" }
}

resource "aws_iam_role_policy" "ec2_instance_role" {
  name = "${var.lab_prefix}-ec2-role-policy"
  role = aws_iam_role.ec2_instance_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter*"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken", "ecr:BatchGetImage"]
        Resource = "*"
      },
      {
        Sid      = "PivotToLambda"
        Effect   = "Allow"
        Action   = ["sts:AssumeRole"]
        Resource = "arn:aws:iam::${var.account_id}:role/${var.lab_prefix}-lambda-execution-role"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_role" {
  name = "${var.lab_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

# ── Rol: lambda-execution-role (objetivo final) ────────────
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.lab_prefix}-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      },
      {
        Sid    = "AllowEC2RolePivot"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:role/${var.lab_prefix}-ec2-instance-role"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = { Lab = "misconfig" }
}

resource "aws_iam_role_policy_attachment" "lambda_admin" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ── Rol: cross-account trust abuse ────────────────────────
resource "aws_iam_role" "cross_account_role" {
  name = "${var.lab_prefix}-cross-account-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "*" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = { Lab = "misconfig" }
}

resource "aws_iam_role_policy" "cross_account_role" {
  name = "${var.lab_prefix}-cross-account-policy"
  role = aws_iam_role.cross_account_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:*", "ec2:Describe*", "iam:List*"]
      Resource = "*"
    }]
  })
}
