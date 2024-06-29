provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  
  key_name = var.key_name
  
  security_groups = ["web-traffic"]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx

              # Clone the static website repository from Git
              git clone https://github.com/arshdej/hng-11.git /tmp/static-page/01

              # Copy the website files to the NGINX web directory
              sudo cp -r /tmp/static-page/01/* /usr/share/nginx/html/

              # Clean up temporary files
              rm -rf /tmp/static-page/01
              EOF
  
  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_traffic" {
  name        = "web-traffic"
  description = "Allow web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
