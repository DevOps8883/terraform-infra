data "aws_ami" "amazon_linux" { 
  most_recent = true
  owners      = ["amazon"]

  filter { 
    name = "name" 
    values = ["al2023-ami-*"] 
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2" {
  vpc_id = var.vpc_id
  
  ingress = [] 

  egress { 
    from_port = 0 
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  tags                   = { Name = "web-instance" }
}