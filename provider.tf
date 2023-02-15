terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/mnt/c/Users/gluckhun/OneDrive/my_workspace/aws/f_p/credentials"]
  profile                  = "terraform_user"

}