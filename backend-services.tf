/*Db subnet group for  high  availability  */
resource "aws_db_subnet_group" "rds_subnet_grp" {
  name       = "rds_subnet_grp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]


  tags = {
    Name = "RDS subnet group"
  }


}

/*Elasticcache subnet group   */

resource "aws_elasticache_subnet_group" "elasticache_subnet_grp" {
  name       = "elasticache_subnet_grp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = " Elasticache subnet group"
  }
}


/*Create Elastic cache instances */

resource "aws_db_instance" "RDS_instance" {
  db_name           = var.DB_name
  allocated_storage = 1
  /*The  least  costly storage type*/
  storage_type   = "gp2"
  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  username       = var.RDS_USER
  password       = var.RDS_PASSWORD
  /*In AWS RDS, a DB parameter group acts as a container for engine configuration values that can be applied to one or more DB instances*/
  parameter_group_name = "default .mysql5.7"
  multi_az             = "false"
  publicly_accessible  = "false"
  /*Skip final snapshot helps u  save  time   when u  are  testing  but  is   necessary  to make this false while production  */
  /*You should have  snapshot  for  database  recovery  */
  skip_final_snapshot    = "true"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_grp.name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

}
/* AWS elasticache cluster*/

resource "aws_elasticache_cluster" "project_cache" {
  cluster_id           = "project-cache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  port                 = 11211
  security_group_ids   = [aws_security_group.backend_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_grp.name

}

resource "aws_mq_broker" "project_rmq" {
  broker_name        = "project_mq_broker"
  engine_type        = "ActiveMQ"
  engine_version     = "5.17.6"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.backend_sg.id]
  subnet_ids         = [module.vpc.private_subnets[0]]

  user {
    username = var.MQ_USER
    password = var.MQ_PASSWORD
  }
}
