resource "aws_iam_user" "demo_user"  {
    name ="Linux"
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.demo_user.name
}

