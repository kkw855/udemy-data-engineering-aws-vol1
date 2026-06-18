# 1. VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # AWS DNS 리졸버 활성화 (기본값이지만 명시 가능)
  enable_dns_hostnames = true # 퍼블릭 DNS 호스트네임 부여 활성화

  tags = {
    Name  = "data-engg-on-aws-vpc"
    Owner = "www.3aayaam.in"
  }
}

# 2. 인터넷 게이트웨이 생성 (외부 통신용)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "data-engg-on-aws-vpc-igw"
  }
}

# 3-1. 프라이빗 서브넷 생성
resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "data-engg-on-aws-vpc-priv-subnet-${each.key}"
  }
}

# 3-2. 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true # 인스턴스 생성 시 퍼블릭 IP를 자동으로 할당

  tags = {
    Name = "data-engg-on-aws-vpc-pub-subnet-${each.key}"
  }
}

# 4-1. 프라이빗 서브넷용 라우팅 테이블
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "data-engg-on-aws-vpc-priv-rt"
  }
}

# 4-2. 라우팅 테이블 생성 (인터넷 게이트웨이로 향하는 길잡이)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                 # 목적지: 외부 인터넷 전체
    gateway_id = aws_internet_gateway.igw.id # 타깃: 인터넷 게이트웨이로 보내라!
  }

  tags = {
    Name = "data-engg-on-aws-vpc-pub-rt"
  }
}

# 5. 라우팅 테이블 일괄 연결
resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}
