terraform {
  backend "s3" {
    bucket = "my-eks-terraform-testing"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
