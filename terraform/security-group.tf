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
