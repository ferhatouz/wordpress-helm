resource "aws_security_group" "noncompliant" {
  name        = "allow_ssh_noncompliant"
  description = "allow_ssh_noncompliant"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH rule"
    from_port        = 22
    to_port          = 22 # SSH traffic
    protocol         = "tcp"
    cidr_blocks      = ["104.181.144.186/32"] # from all IP addresses is authorized
  }
}

resource "aws_s3_bucket" "mynoncompliantsecondbucket" {  # sensitive (s6281)
  bucket = "mynoncompliantsecondbucketname"
}

resource "aws_s3_bucket_public_access_block" "mynoncompliantspublicaccess" {
  bucket = aws_s3_bucket.mynoncompliantsecondbucket.id

  block_public_acls       = false # should be true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}