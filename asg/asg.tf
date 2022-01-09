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

resource "aws_autoscaling_group" "asg" {
  desired_capacity                      = var.INSTANCE_COUNT
  max_size                              = var.ASG_MAX_SIZE
  min_size                              = var.ASG_MIN_SIZE
  vpc_zone_identifier                   = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS
  target_group_arns                     = [aws_lb_target_group.target-group.arn]

  launch_template {
    id                                  = aws_launch_template.template.id
    version                             = "$Latest"
  }
}

