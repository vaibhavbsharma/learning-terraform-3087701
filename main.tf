# Fetch the latest official Ubuntu 24.04 AMI
data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical's official AWS Owner ID
  owners = ["099720109477"] 
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.nano"

  # Bootstraps the instance to install Tomcat on startup
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y tomcat9
              systemctl enable tomcat9
              systemctl start tomcat9
              EOF

  tags = {
    Name = "HelloWorld"
  }
}
