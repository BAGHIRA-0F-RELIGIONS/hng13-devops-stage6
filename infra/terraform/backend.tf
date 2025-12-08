terraform {
  backend "s3" {
   bucket = "hasmoent-tf-backend"
   key    = "tfstate"
   region = "us-east-1"
   dynamodb_table = "terraform-locks"
  }
}

# terraform {
#   backend "local" {
#   }
# }
