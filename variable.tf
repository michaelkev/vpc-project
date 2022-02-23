variable "vpc-cidr" {
  default ="192.168.0.0/16"
  description = "vpc cidr block"
  type = string
}
variable "public-subnet-1-cidr" {
  default ="192.168.1.0/24"
  description = "public subnet 1 cidr block"
  type = string
}
variable "private-subnet-1-cidr" {
  default ="192.168.2.0/24"
  description = "private subnet 1 cidr block"
  type = string
}