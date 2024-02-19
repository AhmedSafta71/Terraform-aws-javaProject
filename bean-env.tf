resource "aws_elastic_beanstalk_environment" "project_elastic_beanstalk_env" {
  name                = "beanstalk-env"
  application         = aws_elastic_beanstalk_application.elastic_beanstalk_app.id
  solution_stack_name = "64bit Amazon Linux 2 v4.4.0 running Tomcat 8.5 Corretto 11"
  /*In  the  cname_prefix we specify the  url  that must be available and  correct   */
  cname_prefix = "project-bean-prod-domain"

  /*Set all needed settings*/
  /*Settings  for  the vpc*/
  setting {
    /*Namespace defines  the domain of settings  that we  are dealing with */
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.vpc.vpc_id
  }
  /*Settings for  autoscaling groups   */
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    /*
  subnets  accept  as value a  string  if we have a  multiple  subnets then we have to use
    the join function  to convert  the  table  of subnets  value into string holding all subnets seperated by a coma */
    value = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
  }
  /*Settings for  ELB Subnets   */
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }
  /*Settings for autoscaling launching configuration */
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 3"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "minsize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "maxsize"
    value     = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "enviornment"
    value     = "prod"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LOGGING_APPENDER"
    value     = "GRAYLOG"
  } /* Health reporting system efficency
           1. cost efficency
           2.  Performance  efficency
           3. Functionnality effiicency  */

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    /*   enhanced is more exepensive =>  uese basic 4 the  moment  */
    value = "basic"
  }

  /*  This  is efficient when u  want to make  small  updates to elb
        and  avoinding app downtime    */

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    /*   enhanced is more exepensive =>  uese basic 4 the  moment  */
    value = "true"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    /*   enhanced is more exepensive =>  uese basic 4 the  moment  */
    value = "HEALTH"
  }
  /*Specifies the number of instances that are included in  each  batch  of rolling update  */
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }
  /*Enable loadbancing  through  multiple av  zones */
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }
  /* Stickiness enabled  */
  /*Set to true to enable sticky sessions.This option is only applicable to environments with an application load balancer.*/
  /*This feature is particularly useful for maintaining session persistence in stateful applications or for ensuring a consistent user experience across multiple interactions with the application.*/
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessEnabled"
    value     = "true"
  }
  /*The BatchSizeType setting allows you to configure how many instances to process in parallel
when executing environment commands. In this case, setting the value to "Fixed" indicates that a fixed batch size will be used.*/
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Fixed"
  }
  /*
        Rolling Deployment: In a Rolling deployment, Elastic Beanstalk will deploy the new version of your application gradually, by replacing instances in batches.
        It ensures that your application remains available throughout the deployment process, as it gradually replaces old instances with new ones.*/

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling "
  }
  /*  In this section  we will  put the settings of  Security groups   */


  /*1 Here at   first we will  mention the  seccurity groups that will be assigned to  instances in the   beanstalk   stack */

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    /*  The   value is  security group  ids */
    value = aws_security_group.prod_sg.id
  }
  /*Attach a  security group to a  load balancer  if not assigned ebeanstalk will attribute a default one  */
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    /*  The   value is  security group  ids */
    value = aws_security_group.elb_sg.id
  }
  /*We notice  that  elastic beanstalk depends of securiy groups   so  we  have   to add dependency  in terraform to  avoid conflict */
  depends_on = [aws_security_group.elb_sg, aws_security_group.prod_sg]





}


