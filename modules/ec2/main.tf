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

}
  
  # 2. Add your persistent, tracked ports as standalone resources

resource "aws_vpc_security_group_ingress_rule" "app_port" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8081      # Your primary managed port
  ip_protocol       = "tcp"
  to_port           = 8081
}

# 3. Add your standard egress as a standalone resource
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Semantically matches your original protocol = "-1"
}



resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  tags                   = { Name = "web-instance" }
}