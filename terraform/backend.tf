terraform {
  cloud {
    organization = "nasu-dev"
    workspaces {
      name = "aws-2048-cicd-pipeline"
    }
  }
  required_version = "~> 1.12.0"
}
