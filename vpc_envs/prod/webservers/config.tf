terraform {
  backend "s3" {
    bucket = "acs730-group2-project"        // Bucket where to SAVE Terraform State. Provide your unique custom name
    key    = "prod/instances/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                          // Region where bucket is created
  }
}