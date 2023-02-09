terraform {
  cloud {
    organization = "tafari"

    workspaces {
      name = "DevOps-The-Hard-Way-AWS-Infrastructure"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region

}

