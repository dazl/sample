# TODO: replace actual values where appropriate

/*
empty value blocks are for secrets to be found in
terraform.tfvars which is not committed to git
*/
variable "access_key" {}
variable "secret_key" {}
variable "datadog_api_key" {}
variable "datadog_app_key" {}

variable "environment" {
  default = "dev"
}
variable "region" {
  default = "us-east-1"
}
variable "service" {
  default = "myprojectservice"
}
variable "team" {
  default = "myprojectteam"
}
variable "vpc_id" {
    default = "myprojectvpcID"
}
variable "vpc_security_groups" {
  default = ["myprojectsecuritygroup"]
}
variable "subnet_ids" {
    default = [ "myprojectsubnetID-1",
                "myprojectsubnetID-2" ]
}
