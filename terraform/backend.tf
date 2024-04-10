terraform {
  backend "s3" {
    key            = "pek3s-infra"
    region         = "us-east-1"
    bucket         = "terraform-pek3s-state"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}