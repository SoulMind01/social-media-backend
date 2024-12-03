resource "aws_instance" "bastion_host" {
  ami                    = "ami-0d53d72369335a9d6" # Ubuntu 22.04 in us-west-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id] # Replace `security_groups` with this

  key_name                    = "bastion-key" # Replace with your existing key pair or create one
  associate_public_ip_address = true

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file("~/.ssh/id_rsa.pub") # Replace with the path to your SSH public key
}

output "bastion_ip" {
  value = aws_instance.bastion_host.public_ip
}
