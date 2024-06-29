variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "access_key" {
  description = "The access key from aws credential"
  type        = string
}

variable "secret_key" {
  description = "The secret key from aws credential"
  type        = string
}

variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
