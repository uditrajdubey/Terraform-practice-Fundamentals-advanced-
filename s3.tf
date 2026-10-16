resource "aws_s3_bucket" "my_bucket" {
  bucket = "udits-tf-test-bucket"

  tags = {
    Name        = "udits bucket"
    Environment = "Dev"
  }
}
