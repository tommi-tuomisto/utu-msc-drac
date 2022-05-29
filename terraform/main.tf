terraform {
  required_version = ">= 1.0.9"
  required_providers {
    aws        = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    } 
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.3"
    }
    local      = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}

provider "aws" {
  profile = var.environment
  region  = var.region
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}
