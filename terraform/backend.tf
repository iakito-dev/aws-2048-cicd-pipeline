terraform {
  backend "s3" {
    bucket         = "terraform-state-2048-game"
    key            = "project-1/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
