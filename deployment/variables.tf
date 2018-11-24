variable "aws_credentials_file" {
  description = "The location of your AWS Credentials file"
  default = "~/.config/aws/credentials"
}

variable "aws_profile" {
  description = "The profile you want in your AWS Credentials file"
  default = "p_terraform_books"
}

variable "aws_region" {
  description = "The region in AWS to put the VM"
  default = "eu-west-1"
}

variable "aws_instance_type" {
	description = "The type of VM to provision"
	default = "t2.micro"
}
