# 1. Redshift 서비스가 이 Role을 가질 수 있도록 허용하는 신뢰 정책 (Trust Policy)
data "aws_iam_policy_document" "redshift_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"] # "Redshift - Customizable"에 해당
    }

    actions = ["sts:AssumeRole"]
  }
}

# 2. IAM Role 생성
resource "aws_iam_role" "redshift_s3_role" {
  name               = "data-engg-on-aws-redshift-s3fullaccess-role"
  assume_role_policy = data.aws_iam_policy_document.redshift_assume_role.json

  tags = {
    Name = "data-engg-on-aws-redshift-s3fullaccess-role"
  }
}

# 3. IAM Role에 S3 접근 권한 정책 연결 (Attachment)
# 예시로 S3 데이터를 읽어오는 COPY 명령만 쓴다면 ReadOnlyAccess로 충분합니다.
resource "aws_iam_role_policy_attachment" "redshift_s3_full" {
  role       = aws_iam_role.redshift_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
