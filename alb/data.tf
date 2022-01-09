data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket                = "terraform-szs" 		                    ##urs bucket name
    key                   = "immutable/vpc/${var.ENV}/terraform.tfstate"
    region                = "us-east-1"
  }
}
