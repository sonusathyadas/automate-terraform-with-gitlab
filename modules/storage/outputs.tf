output "bucket_dns" {
  value = aws_s3_bucket.my-bucket.bucket_domain_name
}