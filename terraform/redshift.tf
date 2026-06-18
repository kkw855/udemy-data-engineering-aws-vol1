# redshift-cluster-1

# 3. Amazon Redshift 클러스터 생성
resource "aws_redshift_cluster" "mysample_cluster" {
  cluster_identifier = "ra3aws-redshift-cluster"
  database_name      = "dev"
  master_username    = "awsuser"
  master_password    = "SecurePassword123!" # TODO: ⚠️ 실제 환경에서는 변수(Variables)나 Secrets Manager를 활용하세요.

  # ⚙️ 요청하신 ra3.large 노드 유형 설정
  # ra3.large 인스턴스는 고가용성 및 성능 분산을 위해 최소 2개의 노드(Multi-node) 구성을 권장합니다.
  node_type       = "ra3.large"
  cluster_type    = "multi-node"
  number_of_nodes = 2

  # 이전에 생성한 서브넷 그룹 지정
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_private_subnet_group.name

  # 🔒 프라이빗 서브넷에 배치되므로 퍼블릭 접근을 완전히 차단합니다.
  publicly_accessible = false

  # 🔗 생성한 IAM Role의 ARN을 여기에 연결합니다.
  iam_roles = [aws_iam_role.redshift_s3_role.arn]
}
