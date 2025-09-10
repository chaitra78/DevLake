terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

resource "aws_instance" "openproject" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  user_data = <<-EOF
             #!/bin/bash
# Update system and install Docker
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
 
# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)"…
chmod +x /usr/local/bin/docker-compose
 
# Create DevLake directory
mkdir -p /opt/devlake
cd /opt/devlake
 
# Download DevLake docker-compose file
curl -O https://raw.githubusercontent.com/apache/incubator-devlake/main/docker-compose.yml
 
# Start DevLake
docker-compose up -d

  tags = {
    Name = "DevLake"
  }
}
