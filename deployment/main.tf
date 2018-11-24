provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${pathexpand(var.aws_credentials_file)}"
  profile                 = "${var.aws_profile}"
}

resource "aws_security_group" "security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

data "aws_ami" "aws_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = "${file("id_rsa.pub")}"
}

resource "aws_eip" "ip" {}

resource "aws_eip_association" "ip_association" {
  instance_id   = "${aws_instance.books.id}"
  allocation_id = "${aws_eip.ip.id}"
}

resource "aws_instance" "books" {
  ami           = "${data.aws_ami.aws_linux.id}"
  instance_type = "${var.aws_instance_type}"

  vpc_security_group_ids = ["${aws_security_group.security_group.id}"]

  # associate_public_ip_address = true

  key_name = "${aws_key_pair.ssh_key.key_name}"
  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("id_rsa")}"
    }

    source      = "files"
    destination = "/tmp/files"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("id_rsa")}"
    }

    script = "script.sh"
  }
  tags {
    Name = "terraform_books"
  }
}

output "ip" {
  value = "${aws_instance.books.public_ip}"
}
