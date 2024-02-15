/*S3 bucket to  store all terraform state */
terraform {
  /*terraform supports a  lot of  backend services */
  backend "s3" {
    bucket = "tf-st-bucket-itpeac"
    key    = "terraform/backend"
    region = "us-east-1"

  }
}