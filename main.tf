# terraform {
#   required_version = ">= 0.9.11"
#   backend "s3" {                             # TODO: replace with actual values
#     bucket = "myprojectbucket"
#     key    = "myprojectkey"
#     region = "myprojectbucketregion"
#   }
# }
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}
