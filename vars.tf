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
  default = "183.83.38.124/32"
}
/*Secuity group for  bastion host  */
/* ================== */


/* Creting rmq user   for  aws activeMQ*/
variable "MQ_USER" {
  default = "saftaMq"
}
/* Creting rmq user password   for  aws activeMQ*/
variable "MQ_PASSWORD" {
  default = "saftaMqPasswd"
}
/*RDB connection user */
variable "RDB_USER" {
  default = "saftaRDB"
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
  default = "saftardbPasswd"
}
/* VPC Name  */

variable "VPC_NAME" {
  default = "java-project-vpc"
}

variable "VPC_CIDR" {
  default = "172.12.0.0/16"
}

/* Public and private subnets    */
variable "PUB_SUB1" {
  default = "172.12.1.0/24"
}
variable "PUB_SUB2" {
  default = "172.12.2.0/24"
}
variable "PUB_SUB3" {
  default = "172.12.3.0/24"
}
variable "PRV_SUB1" {
  default = "172.12.4.0/24"
}
variable "PRV_SUB2" {
  default = "172.12.5.0/24"
}
variable "PRV_SUB3" {
  default = "172.12.6.0/24"
}