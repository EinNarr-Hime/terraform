# EC2の設定
resource "aws_instance" "sample" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.sample.id}"]
  subnet_id              = aws_subnet.sample.id
  key_name               = aws_key_pair.sample.id
  iam_instance_profile   = aws_iam_instance_profile.sample.id
  user_data              = file("./user_data/ec2_setup.sh")
  tags = {
    Name = "${local.sample_tags.Name}"
  }
}

# EIPとEC2の紐付け
resource "aws_eip" "sample" {
  instance = aws_instance.sample.id
  vpc      = true
  tags = {
    Name = "${local.sample_tags.Name}"
  }
}

# セキュリティグループの作成
resource "aws_security_group" "sample" {
  name   = "${var.name}_sg"
  vpc_id = aws_vpc.sample.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.sample_tags.Name}_sg"
  }
}

# インバウンドルールの設定(自分のIPからのみsshアクセスを許可)
resource "aws_security_group_rule" "ssh_from_vpn" {
  type              = "ingress"
  from_port         = 60022
  to_port           = 60022
  protocol          = "tcp"
  cidr_blocks       = [var.my_public_cidr]
  security_group_id = aws_security_group.sample.id
}
