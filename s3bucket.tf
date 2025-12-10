provider "aws" {                                         # echo "Hello from Terraform!" > myfile.txt

  region = "ap-south-1"
}

# ---------------------------
#  CREATE S3 BUCKET
# ---------------------------
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-sagar-bucket-1234567"                        # bucket name must be globally unique

  tags = {
    Name = "MyTerraformBucket"
  }
}

# ---------------------------
#  UPLOAD FILE TO BUCKET
# ---------------------------
resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "myfile.txt"                                                   # This will be the filename in S3
  source = "${path.module}/myfile.txt"                                    # Path of file on your system
  etag   = filemd5("${path.module}/myfile.txt")                           # This line is for file integrity and change detection
}
