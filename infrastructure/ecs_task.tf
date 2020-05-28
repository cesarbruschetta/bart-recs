resource "aws_ecs_cluster" "bartSimulatorECSCluster" {
  name = "bart-simulator"
 
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  }

}

module "ecs_scheduled_task" {
  source                = "git::https://github.com/tmknom/terraform-aws-ecs-scheduled-task.git?ref=tags/2.0.0"
  name                  = "bart-simulator-send-pageview"
  description           = "Envia os dado ao GA 3x ao dia"
  enabled               = true
  
  create_ecs_task_execution_role = false
  ecs_task_execution_role_arn    = "${aws_iam_role.bartSimulatorTaskExecutionRole.arn}"
  
  cluster_arn           = "${aws_ecs_cluster.bartSimulatorECSCluster.arn}"
  subnets               = module.vpc.public_subnet_ids
  assign_public_ip      = true

  schedule_expression   = "rate(8 hours)"
  
  container_definitions = <<DEFINITION
[
    {
        "name": "simulator",
        "image": "cesarbruschetta/bart-simulator:latest",
        "cpu": 256,
        "memory": 512,
        "networkMode": "awsvpc",
        "command": [
            "simulator" ,
            "send-data-ga",
            "pageview",
            "-c",
            "https://raw.githubusercontent.com/cesarbruschetta/bart-recs/master/datasets/customers.csv",
            "-p",
            "https://raw.githubusercontent.com/cesarbruschetta/bart-recs/master/datasets/products.csv",
            "--random-interactions"
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "bart-simulator",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "task"
            }
        }
    }
]
DEFINITION

  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  } 

}

locals {
  cidr_block = "10.255.0.0/16"
}

module "vpc" {
  source  = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/2.0.1"
  name    = "bart-simulator-scheduled-task-vpc"
  
  cidr_block                = local.cidr_block
  public_subnet_cidr_blocks = [
    cidrsubnet(local.cidr_block, 8, 0),
    cidrsubnet(local.cidr_block, 8, 1)
  ]
  
  public_availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]
  
  tags = {
    Project     = "bart-recs"
    Environment = "PRD"
  } 
}
