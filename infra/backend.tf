terraform {
  backend "s3" {
    bucket = "soatfiap-fase4"
    key    = "state/oficina-db/terraform.tfstate"
    region = "us-east-1"
  }
}
