variable "REGION" {
  default = "us-east-1"
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
    us-east-1 = "ami-0c7217cdde317cfec"
    us-east-2 = "ami-05fb0b8c1424f266b"
  }

}
/*SPecify the  path for  the  private key  file */
variable "PRIVATE_KEY_PATH" {
  default = "projectKey"
}
/*Specify the  path for  the  public key  file */
variable "PUBLIC_KEY_PATH" {
  default = "projectKey.pub"
}
variable "USERNAME" {
  default = "ubuntu"
}
variable "MYIP" {
  default = ""
}
/*Secuity group for  bastion host  */
/* ================== */


/* Creting rmq user   for  aws activeMQ*/
variable "MQ_USER" {
  default = ""
}
/* Creting rmq user password   for  aws activeMQ*/
variable "MQ_PASSWORD" {
  default = ""
}
/*RDB connection user */
variable "RDB_USER" {
  default = ""
}
/*RDB Database name */

variable "DB_name" {
  default = "accounts"
}

/* Instance Count to create a number of idetentical instances  at the same  time   */
variable "INSTANCE_COUNT" {
  default = "1"
}

/*RDB Connection user passwd */
variable "RDB_PASSWORD" {
  default = ""
}
/* VPC Name  */

variable "VPC_NAME" {
  default = "java-project-vpc"
}

variable "VPC_CIDR" {
  default = ""
}

/* Public and private subnets    */
variable "PUB_SUB1" {
  default = ""
}
variable "PUB_SUB2" {
  default = ""
}
variable "PUB_SUB3" {
  default = ""
}
variable "PRV_SUB1" {
  default = ""
}
variable "PRV_SUB2" {
  default = ""
}
variable "PRV_SUB3" {
  default = ""
}
