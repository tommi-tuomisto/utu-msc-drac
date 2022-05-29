#ec2
resource "aws_instance" "web" {
  ami                         = var.al2_ami_version
  instance_type               = "t3.small"
  associate_public_ip_address = true
  private_ip                  = "10.0.0.6"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.allow_default.id, aws_security_group.allow_web.id]
  user_data                   = file("${path.module}/shell/init_ssh.sh")
  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "liferay-tier1-web"
  }
}

resource "aws_instance" "app" {
  ami                         = var.al2_ami_version
  instance_type               = "t3.large"
  associate_public_ip_address = true
  private_ip                  = "10.0.0.8"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.allow_default.id, aws_security_group.allow_app.id]
  user_data                   = file("${path.module}/shell/init_ssh.sh")
  root_block_device {
    volume_size = 10
  }
  tags = {
    Name = "liferay-tier2-app"
  }
}

resource "aws_instance" "database" {
  ami                         = var.al2_ami_version
  instance_type               = "t3.small"
  associate_public_ip_address = true
  private_ip                  = "10.0.0.10"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.allow_default.id, aws_security_group.allow_db.id]
  user_data                   = file("${path.module}/shell/init_ssh.sh")
  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "liferay-tier3-db"
  }
}

resource "aws_instance" "search" {
  ami                         = var.al2_ami_version
  instance_type               = "t3.small"
  associate_public_ip_address = true
  private_ip                  = "10.0.0.12"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.allow_default.id, aws_security_group.allow_se.id]
  user_data                   = file("${path.module}/shell/init_ssh.sh")
  root_block_device {
    volume_size = 8
  }
  tags = {
    Name = "liferay-tier3-se"
  }
}
