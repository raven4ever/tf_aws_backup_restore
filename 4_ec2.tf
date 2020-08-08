resource "aws_network_interface" "web_server_nic" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["10.0.1.50"]
  security_groups = [
    aws_security_group.allow_web.id,
    aws_security_group.ec2.id,
    aws_security_group.mnt.id
  ]

  tags = {
    name    = "web_server_nic"
    project = "aws_backup_restore"
  }
}

resource "aws_instance" "web_server_instance" {
  ami               = "ami-07d9160fa81ccffb5"
  instance_type     = "t2.micro"
  key_name          = "main_key"
  availability_zone = "eu-west-1a"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_server_nic.id
  }

  volume_tags = {
    owner   = "web_server_instance"
    project = "aws_backup_restore"
  }

  root_block_device {
    delete_on_termination = true
  }

  user_data = file("install_apache.sh")

  tags = {
    name    = "web_server"
    project = "aws_backup_restore"
  }
}
