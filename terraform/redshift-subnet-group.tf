resource "aws_redshift_subnet_group" "redshift_private_subnet_group" {
  name        = "data-engg-on-aws-redshift-subnet-grp"
  description = "Redshift cluster subnet group for private subnets"

  # aws_subnet.private 맵을 순회하면서 각각의 id값만 모아 리스트를 만듭니다.
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = "data-engg-on-aws-redshift-subnet-grp"
  }
}
