resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = "Security group"
  vpc_id      = var.vpc_id

  # Allow SSH from anywhere by default (you can override by editing module)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
