resource "random_password" "this" {
  length           = var.length
  min_upper        = var.min_upper
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  override_special = var.override_special
}
