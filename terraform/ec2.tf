data "aws_ami" "os_image" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/*amd64*"]
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "bankapp-key"
  public_key = file("bankapp-key.pub")
}


resource "aws_default_vpc" "default" {
  
}


resource "aws_security_group" "allow_user_to_connect" {

	name        = "allow_TLS"
	description = "Allow user to connect"
	vpc_id      = aws_default_vpc.default.id

	ingress {
	
		description = "allow SSH port 22"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {

                description = "allow HTTP port 80"
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

	ingress {

                description = "allow HTTS port 443"
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }


	egress {

                description = "allow outgoing traffic"
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
	
	tags = {
		Name = "bankapp-securitygroup"
		}

}

resource "aws_instance" "testinstance" {


	instance_type = var.instance_type
	ami = data.aws_ami.os_image.id
	key_name = aws_key_pair.deployer.key_name
	security_groups = [aws_security_group.allow_user_to_connect.name]
	root_block_device {
		volume_size = 30
		volume_type = "gp3"
	}
	tags = {
   		 Name        = "Bankapp_Instance"
    		 
  	}




}
