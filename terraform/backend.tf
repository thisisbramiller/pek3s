terraform {
 backend "s3" {
    bucket                  = "terraform-pek3s-state"
    key                     = "pek3s-infra"
    region                  = "us-east-1"
  }
}