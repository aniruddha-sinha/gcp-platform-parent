# //iam
# module "iam" {
#   source = "git::https://github.com/aniruddha-sinha/gcp-iam-module?ref=main"
#   //source = "../../modules/iam"

#   project_id                   = "odin-sixteen"
#   service_account_id           = "storage-sa"
#   service_account_display_name = "Google Cloud Storage Service Account"
#   role_list = [
#     "roles/storage.admin",
#     "roles/iam.serviceAccountViewer",
#     "roles/resourcemanager.projectIamAdmin"
#   ]
# }

# resource "google_storage_bucket_iam_member" "storage_sa_storage_admin_for_state_bkt" {
#   depends_on = [
#     module.iam
#   ]
#   bucket = "odin-admin-state-bkt"
#   role   = "roles/storage.admin"
#   member = "serviceAccount:storage-sa@odin-sixteen.iam.gserviceaccount.com"
# }