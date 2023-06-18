resource "aws_instance" "web" {
  ami           = ami-03265a0778a880afb
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]


  tags = {
    Name = var.name
  }

resource "null_resource" "ansible" {
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.web.public_ip
    }

    inline = [
      "sudo labauto ansible",
      "ansible-pull -i localhost, -u https:github.com/raghudevopsb73/roboshop-ansible main.yml -e env=dev -e role_name=frontend ",
    ]
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z01135003JT1TK8N0FX0N"
  name    = "${var.name}-dev"
  type    = "A"
  ttl     = 30
  records = [aws_instance.web.private_ip]
}




}

data "aws_ami" "example" {
  owners = ["973714476881"]
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
}

resource "aws_security_group" "sg" {
  name        = var.name
  description = "Allow TLS inbound traffic"


  ingress {
    description      = "SSH"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}

variable "name" {}

output "public_ip" {
  value = aws_instance.web.public_ip
}
