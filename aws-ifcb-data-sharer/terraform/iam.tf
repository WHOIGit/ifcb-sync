# IAM User for full S3 access
resource "aws_iam_user" "prod_bucket" {
  name = "${var.project_name}-s3-bucket"
}

resource "aws_iam_user_policy" "prod_bucket" {
  user = aws_iam_user.prod_bucket.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "${module.s3_bucket.s3_bucket_arn}",
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
      },
    ]
  })
}

# Manage external S3 users with different IAM user/policies

resource "aws_iam_user" "s3_users" {
  for_each      = toset(var.user_names)
  name          = each.value
  force_destroy = true
  tags = {
    Project = "${var.project_name}"
  }
}

# chain outputs from the iam_user loop
resource "aws_iam_user_policy" "s3_users" {
  for_each = aws_iam_user.s3_users
  name     = "${each.value.name}-policy"
  user     = each.value.name
  policy   = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "${module.s3_bucket.s3_bucket_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${module.s3_bucket.s3_bucket_arn}/${each.value.name}/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "${module.s3_bucket.s3_bucket_arn}/${each.value.name}/*"
      
    },
    {
      "Effect": "Allow",
      "Action": "s3:DeleteObject",
      "Resource": "${module.s3_bucket.s3_bucket_arn}/${each.value.name}/*"
      
    }
  ]

}
EOT
}

