provider "aws" {
  profile = var.profile_name
  region  = var.region
}

# ssh公開鍵を登録
resource "aws_key_pair" "sample" {
  key_name   = var.name
  public_key = file(var.ssh_public_key_path)
}

locals {
  sample_tags = {
    Name = "${var.name}"
  }
}

#　インスタンスプロファイル作成
resource "aws_iam_instance_profile" "sample" {
  name = var.name
  role = aws_iam_role.sample.name
}

# ロール作成
resource "aws_iam_role" "sample" {
  name               = var.name
  assume_role_policy = file("./policy/assume_role_policy.json")
}

# S3用のポリシー
resource "aws_iam_policy" "sample_s3" {
  tags   = local.sample_tags
  name   = "${var.name}_s3"
  policy = file("./policy/s3_policy.json")
}

# SessionManager用のポリシー
resource "aws_iam_policy" "sample_ssm" {
  tags   = local.sample_tags
  name   = "${var.name}_ssm"
  policy = file("./policy/ssm_policy.json")
}

# ロールにポリシーを紐付け
resource "aws_iam_role_policy_attachment" "sample_s3" {
  role       = aws_iam_role.sample.name
  policy_arn = aws_iam_policy.sample_s3.arn
}
resource "aws_iam_role_policy_attachment" "sample_ssm_1" {
  role       = aws_iam_role.sample.name
  policy_arn = aws_iam_policy.sample_ssm.arn
}
resource "aws_iam_role_policy_attachment" "sample_ssm_2" {
  role       = aws_iam_role.sample.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "sample_ssm_3" {
  role       = aws_iam_role.sample.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}