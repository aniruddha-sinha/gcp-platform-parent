//vpc
module "vpc" {
  source = "github.com/aniruddha-sinha/gcp-network-module.git?ref=master"
  //source = "../../modules/vpc"

  project-id               = "odin-twenty"
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}

//iam: not needed for autopilot
module "iam" {
  source = "github.com/aniruddha-sinha/gcp-iam-module.git?ref=main"
  //source = "../../modules/iam"

  project_id                   = "odin-twenty"
  service_account_id           = "gke-sa"
  service_account_display_name = "GKE Service Account"
  role_list = [
    "roles/editor"
  ]
}

data "google_container_engine_versions" "k8s_versions" {
  project  = "odin-twenty"
  provider = google-beta
  location = "us-central1"
}

//autopilot cluster new module
module "vulcan" {
  depends_on = [
    module.vpc,
    # module.iam
  ]

  source = "github.com/aniruddha-sinha/google-kubernetes-engine//autopilot?ref=main"

  k8s_cluster_name                 = "vulcan"
  project_id                       = "odin-twenty"
  region                           = "us-central1"
  k8s_version                      = data.google_container_engine_versions.k8s_versions.release_channel_default_version["REGULAR"]
  master_auth_ip_whitelisting_name = "my-mac-public-ip"
  #public_ip_address_of_the_system  = "43.251.74.0/24"
  public_ip_address_of_the_system = "103.252.164.0/24"
}

module "sql" {
  source = "github.com/aniruddha-sinha/cloudsql?ref=main"

  instance_name = "xcite-0411"
  project_id    = "odin-twenty"
  region        = "us-central1"
  db_tier       = "db-f1-micro"
  disk_size     = "120"
  disk_type     = "PD_HDD"
  user_labels = {
    "purpose" = "learning"
  }
}