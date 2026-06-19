resource "aws_key_pair" "my-key-pair" {
  key_name   = "my-key-pair"
  public_key = file("${path.module}/terraform-key.pub")
}
