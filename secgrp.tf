resource "aws_security_group" "elb_sg" {
  name        = "project_elb_sg"
  description = "Security group for java Project elb"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all  incoming  traffic"
  }

  tags = {
    Name = "project_elb_sg"
  }
}
/* Sg for  bastion host  */

resource "aws_security_group" "bastion_sg" {
  name        = "project_bastion_sg"
  description = "Security group for java Project bastion host"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.MYIP]
    description = "Allow all  incoming  traffic"
  }

  tags = {
    Name = "project_bastion-host_sg"
  }
}

/* Sg for the  beanstalk prod env */

resource "aws_security_group" "prod_sg" {
  name        = "project_prod_sg"
  description = "Security group for java Project  Elastic beanstalk service (Prod)"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "SSH prod env  from the  bastion host"
  }
  tags = {
    Name = "project_production-beanstalk_sg"
  }
}
/* Sg for the  backend env */

resource "aws_security_group" "backend_sg" {
  name        = "project_backend_sg"
  description = "Security group for java Project backend (Active MQ, RDS,elastic cache"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.prod_sg.id]
    description     = "Accept all traffic from  the beanstalk instances "
  }
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "Allow the traffic from the bastion host"
  }


  tags = {
    Name = "project-backend_sg"
  }
}
/* Security  Group rule  :  enables all  the  instances  inside the same security group to exchange  traffic    */
resource "aws_security_group_rule" "backened-traffic-rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.backend_sg.id
}