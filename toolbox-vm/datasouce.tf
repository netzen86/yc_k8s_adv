data "yandex_compute_image" "toolbox" {
  family = "toolbox"
}

data "yandex_iam_service_account" "terraform-sa" {
  name = "terraform-sa"
}
