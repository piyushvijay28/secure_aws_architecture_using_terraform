variable "ami" {
  description = "for practice ec2"
  type        = string
  default     = "ami-0f918f7e67a3323f0"
}

variable "aws_vpc_cidr" {
  description = "value for vpc cidr block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "value of cidr block for public subnet"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "value of of cidr block for private subnet"
  type        = list(string)
  default     = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
}

variable "azs" {
  description = "value for Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

}
