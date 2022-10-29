//vpc
module "vpc" {
  source = "git::https://github.com/aniruddha-sinha/gcp-network-module?ref=master"
  //source = "../../modules/vpc"

  project-id               = "odin-sixteen"
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}

//iam
module "iam" {
  source = "git::https://github.com/aniruddha-sinha/gcp-iam-module?ref=main"
  //source = "../../modules/iam"

  project_id                   = "odin-sixteen"
  service_account_id           = "gke-sa"
  service_account_display_name = "GKE Service Account"
  role_list = [
    "roles/container.clusterViewer"
  ]
}

//gke
module "gke" {
  depends_on = [
    module.vpc,
    module.iam
  ]

  source = "git::https://github.com/aniruddha-sinha/gke?ref=main"
  //source = "../../modules/gke"

  project_id        = "odin-sixteen"
  autopilot_enabled = var.autopilot_enabled
  #cluster_type       = "zonal"
  service_account_id = "gke-sa"
  custom_labels = {
    "purpose" : "learning"
    "billing" : "central-billing-account-v2"
  }
  region_preference                = "us-central1"
  zone_preference                  = "us-central1-a"
  master_auth_ip_whitelisting_name = "my-mac-public-ip"
  public_ip_address_of_the_system  = "43.251.74.0/24"
  preemptible                      = true
  node_machine_type                = "n1-standard-1"
  node_disk_size_in_gb             = 50
}
