# VPC作成
resource "aws_vpc" "aws-tf-vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "tf-test-vpc"
  }
}
 
# インターネットゲートウェイの作成
resource "aws_internet_gateway" "aws-tf-igw" {
  vpc_id = aws_vpc.aws-tf-vpc.id
  tags = {
    Name = "aws-tf-igw"
  }
}

# ルートテーブルの作成
resource "aws_route_table" "aws-tf-public-route" {
  vpc_id = aws_vpc.aws-tf-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-tf-igw.id
  }
  tags = {
    Name = "aws-tf-public-route"
  }
}

# サブネット２つ作成(publicとprivate)
resource "aws_subnet" "aws-tf-public-subnet-1a" {
  vpc_id            = aws_vpc.aws-tf-vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-tf-public-subnet-1a"
  }
}
 
resource "aws_subnet" "aws-tf-private-subnet-1a" {
  vpc_id            = aws_vpc.aws-tf-vpc.id
  cidr_block        = "10.1.20.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "aws-tf-private-subnet-1a"
  }
}

# サブネットの関連付けでルートテーブルをパブリックサブネットに紐付け
resource "aws_route_table_association" "aws-tf-public-subnet-association" {
  subnet_id      = aws_subnet.aws-tf-public-subnet-1a.id
  route_table_id = aws_route_table.aws-tf-public-route.id
}
