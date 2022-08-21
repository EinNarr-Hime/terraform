# apply後にElastic IPを出力する
output "ssh_cmd" {
  value = "ssh -i ${var.ssh_private_key_path} ec2-user@${aws_eip.sample.public_ip} -p 60022"
}
