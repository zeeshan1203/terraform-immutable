data "aws_ami" "component-ami" {
  most_recent      = true
  name_regex       = "^${var.COMPONENT}-*"
  owners           = ["self"]
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket                = "terraform-szs"
    key                   = "immutable/vpc/${var.ENV}/terraform.tfstate"
    region                = "us-east-1"
  }
}

data "aws_secretsmanager_secret" "secrets" {
  name = "${var.ENV}-env"
}

data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

