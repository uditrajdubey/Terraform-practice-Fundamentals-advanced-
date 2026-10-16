# KEY PAIR 

resource "aws_key_pair" "my_key_pair" {
  key_name   = "udit-terraform-key"
  public_key = file("udit-terraform-key.pub")
}

# DEFAULT VPC 

resource "aws_default_vpc" "default" {}

# SECURITY GROUP- (ingress rule + egress rule )

resource "aws_security_group" "my_sg" {
  name        = "udit-sg"
  description = "Allow inbound traffic to port number 22 ssh"
  vpc_id      = aws_default_vpc.default.id


}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0" # anyone can access that 
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Anyone can access that outside the internet 
  ip_protocol       = "-1" # it is used to allow all the protocols (TCP, UDP, ICMP, etc.)
}

#instance cnfig-(ec2 type , ami , key name , vpc-security-group-id)

resource "aws_instance" "my_ec2_instance" {

  ami           = "ami-0b6d9d3d33ba97d99" # Ami id of ubuntu
  instance_type = "t3.micro"              # Instance Type
  vpc_security_group_ids = [aws_security_group.my_sg.id] # Attaches the Security Group
  key_name = aws_key_pair.my_key_pair.key_name # Replace with your existing AWS Key Pair name


# storage giving is optional/ Aws default assigned the storage according to the ami 
    root_block_device {
    volume_size = 30    # Increases space from 8 GB to 30 GB
    volume_type = "gp3" # Upgrades performance and lowers cost compared to gp2
  }


   tags = {
    Name = "udits-ec2-instance" # Change this to your preferred name/it gives the name to your ec2  
    Environment = "Dev"           # Optional extra tag
  }
}