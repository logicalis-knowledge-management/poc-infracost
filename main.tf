resource "aws_instance" "demo" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" 

  root_block_device {
    volume_type = "gp3"
    volume_size = 20 
  }

  tags = {
    Name        = "infracost-demo"
    Environment = "demo"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
