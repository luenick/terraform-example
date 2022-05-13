# Description
This project uses terraform to set up a S3 bucket for public access. The bucket name is set via environment variable.  A test file is uploded and a curl command is run to verify public access. 

# Potential improvements
- Setting region to a variable as well
- Support additional AWS S3 configurations such as bucket versioning, default encryption, server access logging
- Removing public read access and making read permissions tag based or on a per object basis
- Set up a custom domain for an endpoint
- Implement replication for latency and disaster recovery


# Setup
- Install terraform and aws-cli
- Set up a terrform user in AWS IAM in a group with AmazonS3FullAccess permissions
- Run ```aws configure``` to set up credentials under the default profile
- Set up your environment bucket name ```export TF_VAR_bucket_name=yourexamplebucketname```
- You may need to enable stub mode mode for systemd-resolved on your system if you haven't for terraform to perform DNS lookups.  ```ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf```


```
terraform init
terraform validate
terraform apply
terraform show
terraform destroy
```
