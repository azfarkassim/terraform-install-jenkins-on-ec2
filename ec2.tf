# create aws provider, with terraform named profile
provider "aws" {
    region = "us-east-1"
    profile = "terraform"
}

# create vpc resource
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main-vpc"
    }
}

# create subnet resource
resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "main-subnet"
    }
}

# create security group resource
resource "aws_security_group" "ec2_security_group" {
    name = "ec2 SG"
    description = "allow access for http and ssh"
    vpc_id = aws_vpc.main.id

    # allow http from anywhere
    ingress {
        description = "http access"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # allow ssh from anywhere
    ingress {
        description = "ssh access"
        from_port = 22
        to_port = 22
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "jenkins server SG"
    }
}

# get latest amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "owner-alias"
        values = ["amazon"]
    }
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

# create ec2 instance
resource "aws_instance" "jenkins_server" {
    ami = data.aws_ami.amazon_linux_2.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet_1.id
    vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
    key_name = "keypair_pem"

    tags = {
        Name = "jenkins-server"
  }
}

# create null resource block
resource "null_resource" "name" {

    # ssh into ec2 instance
    connection {
        type = "ssh"
        user = "ec2_user"
        private_key = file("keypair_pem.pem")
        host = aws_instance.jenkins_server.public_ip
    }

    # copy installation script to ec2 instance
    provisioner "file" {
        source = "install_jenkins.sh"
        destination = "/tmp/install_jenkins.sh"
    }

    # set executable permission and run installation script
    provisioner "remote-exec" {
        inline = [
            "sudo chmod +x /tmp/install_jenkins.sh",
            "sh /tmp/install_jenkins.sh",
        ]
    }

    # wait for jenkins ec2 instance to start before make connection
    depends_on = [aws_instance.jenkins_server]
}

output "jenkins_url" {
    value = join ("", ["http://", aws_instance.jenkins_server.public_dns, ":8080"])
}

