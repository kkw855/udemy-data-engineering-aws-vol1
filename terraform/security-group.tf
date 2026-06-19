resource "aws_security_group" "private" {
  vpc_id      = aws_vpc.main.id
  name        = "data-engg-on-aws-vpc-priv-sec-grp"
  description = "security group that allows all egress and ingress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = {
    Name = "data-engg-on-aws-vpc-priv-sec-grp"
  }
}

resource "aws_security_group" "public" {
  vpc_id      = aws_vpc.main.id
  name        = "data-engg-on-aws-vpc-pub-sec-grp"
  description = "security group that allows all egress and ingress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "data-engg-on-aws-vpc-pub-sec-grp"
  }
}

# 1. Redshift 전용 보안 그룹 생성
resource "aws_security_group" "redshift_sg" {
  name        = "data-engg-redshift-sg"
  description = "Security group for Redshift cluster in private subnet"
  vpc_id      = aws_vpc.main.id # Redshift가 속한 VPC ID

  tags = {
    Name = "data-engg-redshift-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_rsql_client" {
  security_group_id = aws_security_group.redshift_sg.id
  # 👆 [어디에?] Redshift 보안 그룹에 규칙을 추가할 건데,

  referenced_security_group_id = aws_security_group.rsql_client_sg.id
  # 👆 [누구에게?] RSQL 클라이언트 SG를 가진 리소스의 접근을 허용하겠다.

  from_port   = 5439
  to_port     = 5439
  ip_protocol = "tcp"
}
