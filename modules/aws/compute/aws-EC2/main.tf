resource "aws_instance" "instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip

  # Optional key pair
  key_name = var.key_name != "" ? var.key_name : null

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.volume_delete_on_termination
  }

  # Conditionally include user_data if enabled
  user_data = var.enable_user_data ? templatefile("${path.module}/templates/user_data.tftpl", {}) : null


  tags = {
    Name = var.instance_name
  }
}
