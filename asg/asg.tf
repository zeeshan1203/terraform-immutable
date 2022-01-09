resource "aws_launch_template" "template" {
  name                                  = "${var.COMPONENT}-${var.ENV}"
  image_id                              = data.aws_ami.centos7.id
  instance_market_options {
    market_type                         = "spot"
    spot_options {
      instance_interruption_behavior    = "stop"
      spot_instance_type                = "persistent"
      max_price                         = var.SPOT_PRICE
    }
  }
  instance_type                         = var.INSTANCE_TYPE
  vpc_security_group_ids                = [aws_security_group.allow_ec2.id]
  tag_specifications {
    resource_type                       = "instance"
    tags = {
      Name                              = "${var.COMPONENT}-${var.ENV}"
    }
  }
}

resource "aws_security_group" "allow_ec2" {
  name                        = "allow_${var.COMPONENT}"
  description                 = "allow_${var.COMPONENT}"
  vpc_id                      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description               = "SSH"
    from_port                 = 22
    to_port                   = 22
    protocol                  = "tcp"
    cidr_blocks               = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  ingress {
    description               = "PROMETHEUS"
    from_port                 = 9100
    to_port                   = 9100
    protocol                  = "tcp"
    cidr_blocks               = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  ingress {
    description               = "HTTP"
    from_port                 = var.PORT
    to_port                   = var.PORT
    protocol                  = "tcp"
    cidr_blocks               = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
    ipv6_cidr_blocks          = ["::/0"]
  }

  tags                        = {
    Name                      = "allow_${var.COMPONENT}"
  }
}