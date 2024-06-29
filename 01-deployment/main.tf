provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_instance" "web" {
  ami           = "ami-01b1be742d950fb7f"
  instance_type = var.instance_type
  
  # key_name = var.key_name
  
  security_groups = ["web-traffic"]
  # security_groups = [aws_security_group.default.id]


  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx git -y
              sudo systemctl start nginx
              sudo systemctl enable nginx

              # sudo ufw allow 'Nginx Full'

              mkdir -p tmp
              mkdir -p tmp/static-page
              mkdir -p tmp/static-page/01

              # Clone the static website repository from Git
              rm -rf tmp/static-page/01

              git clone https://github.com/arshdej/hng-11.git tmp/static-page/01

              # Copy the website files to the NGINX web directory
              sudo cp -r tmp/static-page/01/01-static-website/* /usr/share/nginx/html/
              # sudo rm /etc/nginx/sites-enabled/default

              # Clean up temporary files
              # rm -rf tmp/static-page/01
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

output "website_url" {
  value = "http://${aws_instance.web.public_ip}/index.html"
}