resource "aws_instance" "bastion-host-instance" {
  ami = lookup(var.AMIS,var.REGION )
  instance_type = "t2.micro"
  key_name = aws_key_pair.project-key.key_name
  /*Bastion host  will be  created  in the first subnet of  our  vpc  public  subnets group */
  subnet_id = module.vpc.public_subnets[0]
  count  = var.INSTANCE_COUNT
  /*NB: we often  use  security groups with services like dartabases  RDS   that are accessed by security group name
   vpc_security_group_ids  are  used  mainly for  ec2 instances (accessed  by ids  )   b*/
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  tags  ={
    Name = "project-bastion-host"
    Project= "Java-Project"
  }
  /* Set provisioners to   provision  template file */
  provisioner "file" {
    content = templatefile("./templates/db_deploy.tmpl",{rds-endpoint=aws_db_instance.RDS_instance,dbuser=var.RDS_USER,dbpass=var.RDS_PASSWORD } )
    destination= "/tmp/bastion-db-deploy.sh"
  }
/* Set remote-exec provisioner to execte the bash file  created  by the  file provisioner */
  provisioner "remote-exec" {
    /* set  commands  to execute  */
    inline  = [
      "chmod +x /tmp/bastion-db-deploy.sh",
      "sudo /tmp/bastion-db-deploy.sh "
    ]
  }
/*  this connection  to log in to the bastion host */
  connection {
    user  =var.USERNAME
    private_key =  file (var.PRIVATE_KEY_PATH)
    /* the public ip of the bastion host*/
    host= self .public_ip
  }
  /* The bastion host should  only execute after  the  backend services starting (Database )  */
  depends_on = [aws_db_instance.RDS_instance]

}