# 1. AWS가 항상 최신 ID로 업데이트해두는 SSM 경로를 조회
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 2. EC2 인스턴스용 보안 그룹 생성 (SSH 접속 허용)
resource "aws_security_group" "rsql_client_sg" {
  name        = "data-engg-rsql-client-sg"
  description = "Security group for RSQL client EC2 instance"
  vpc_id      = aws_vpc.main.id

  # 인바운드: 외부에서 이 EC2로의 SSH(22번 포트) 접속을 허용합니다.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ 보안을 위해 실제 환경에서는 본인의 공인 IP(예: "X.X.X.X/32")로 제한하세요.
  }

  # 아웃바운드: EC2가 외부 인터넷(RSQL 다운로드 등) 및 프라이빗 Redshift와 통신할 수 있도록 전체 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "data-engg-rsql-client-sg"
  }
}

# 3. RSQL 접속용 EC2 인스턴스 생성
resource "aws_instance" "rsql_client" {
  ami           = data.aws_ssm_parameter.al2023_ami.value
  instance_type = "t3.large"

  # 🔗 [핵심] 제공해주신 local.public_subnets의 "1b" 키값을 지정하여 서브넷 ID를 맵핑합니다.
  subnet_id = aws_subnet.public["1b"].id

  # 보안 그룹 연결
  vpc_security_group_ids = [aws_security_group.rsql_client_sg.id]

  key_name = aws_key_pair.my-key-pair.key_name

  tags = {
    Name = "data-engg-on-aws-rsql-client"
  }
}
