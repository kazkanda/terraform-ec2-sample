# EC2作成(public側)
resource "aws_instance" "aws-tf-web" {
  ami                     = "ami-011facbea5ec0363b"
  instance_type           = "t2.micro"
  disable_api_termination = false
  key_name = aws_key_pair.auth.key_name
  vpc_security_group_ids  = [aws_security_group.aws-tf-web.id]
  subnet_id               = aws_subnet.aws-tf-public-subnet-1a.id
 
  tags = {
    Name = "aws-tf-web"
  }
}
 
# Security Group
resource "aws_security_group" "aws-tf-web" {
  name        = "aws-tf-web"
  description = "aws-tf-web_sg"
  vpc_id      = aws_vpc.aws-tf-vpc.id
  tags = {
    Name = "aws-tf-web"
  }
}
 
# 80番ポート許可のインバウンドルール
resource "aws_security_group_rule" "inbound_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-web.id
}
 
# 22番ポート許可のインバウンドルール
resource "aws_security_group_rule" "inbound_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-web.id
}
 
# アウトバウンドルール
resource "aws_security_group_rule" "outbound_all" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  cidr_blocks = [
    "0.0.0.0/0",
  ]
 
  # ここでweb_serverセキュリティグループに紐付け
  security_group_id = aws_security_group.aws-tf-web.id
}
 
# ElasticIP
resource "aws_eip" "aws-tf-eip" {
  instance = aws_instance.aws-tf-web.id
  vpc      = true
}
# output "example-public-ip" {
#     value = "${aws_eip.aws-tf-eip.public_ip}"
# }
variable "public_key_path" {}
 
resource "aws_key_pair" "auth" {
    key_name = "terraform-aws"
    public_key = file(var.public_key_path)
}
