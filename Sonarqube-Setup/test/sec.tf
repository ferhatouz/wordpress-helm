resource "aws_security_group" "noncompliant" {
  name        = "allow_ssh_noncompliant"
  description = "allow_ssh_noncompliant"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH rule"
    from_port        = 22
    to_port          = 22 # SSH traffic
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # from all IP addresses is authorized
  }
}
