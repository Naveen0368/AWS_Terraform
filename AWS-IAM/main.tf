provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "example_user" {
  name = "example-user"
}

resource "aws_iam_group" "example_group" {
  name = "example-group"
}

resource "aws_iam_group_membership" "example_group_membership" {
  name  = "example-group-membership"
  users = [aws_iam_user.example_user.name]
  group = aws_iam_group.example_group.name
}

resource "aws_iam_policy" "example_policy" {
  name        = "example-policy"
  description = "A test policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ec2:Describe*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "example_group_policy_attachment" {
  group      = aws_iam_group.example_group.name
  policy_arn = aws_iam_policy.example_policy.arn
}
