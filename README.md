# Terraform Moudle to provision an EC2 Instance that is running Apache.

## Not inteded for production use. Just showcase how to create custome module on terraform registry


Usage example:

```
module "apache" {
  source = ".//terraform_aws_apache_example"
  server_name = "Apache Example Server"
  public_key = "ssh-rsa AAAA... "
  ec2_instance_type = "t2.micro"
}
```
