terraform {
  backend "gcs" {
    bucket = "odin-admin-state-bkt"
    prefix = "terraform/platform-state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
