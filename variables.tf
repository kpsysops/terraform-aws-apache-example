variable "public_key" {
  type        = string
  description = "Public Key for EC2 instance"
  sensitive   = true
}

variable "server_name" {
  type = string
  description = "Apache Example Server"
  
}

variable "ec2_instance_type" {
  type = string
  description = "value"
}