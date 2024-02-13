variable "REGION" {
  default = "use-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "ZONE2" {
  default = "us-east-1b"
}

variable "ZONE3" {
  default = "us-east-1c"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-746523045345"
    us-east-2 = "ami-745790594850"
    ap-south-1 ="ami-943547340201"
  }

}
variable "USERNAME" {
  default = "ubuntu"
}
variable  "MYIP"{
  default  =  "183.83.38.124/32"
}