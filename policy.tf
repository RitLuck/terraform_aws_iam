resource "aws_iam_user_policy" "iam" {
  name = "Demo_Policy"
  user = aws_iam_user.demo_user.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListAllMyBuckets*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
