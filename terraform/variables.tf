variable "aws_region" {
  default = "ap-northeast-2"
}

# 프라이빗 서브넷 정보를 담은 로컬 변수 정의
locals {
  private_subnets = {
    "1a" = { cidr = "10.0.10.0/24", az = "${var.aws_region}a" }
    "1b" = { cidr = "10.0.20.0/24", az = "${var.aws_region}b" }
    "1c" = { cidr = "10.0.30.0/24", az = "${var.aws_region}c" }
  }
}

# 퍼블릭 서브넷 정보를 담은 로컬 변수 정의
locals {
  public_subnets = {
    "1a" = { cidr = "10.0.1.0/24", az = "${var.aws_region}a" }
    "1b" = { cidr = "10.0.2.0/24", az = "${var.aws_region}b" }
    "1c" = { cidr = "10.0.3.0/24", az = "${var.aws_region}c" }
  }
}
