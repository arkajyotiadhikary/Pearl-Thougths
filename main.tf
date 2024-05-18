provider "aws" {
  region = "ap-south-1"
}

# Reference existing ECR repository
data "aws_ecr_repository" "my_app" {
  name = "my-app-repo" 
}

# Reference existing IAM role
data "aws_iam_role" "ecs_task_execution" {
  name = "pearl-xyz" 
}

# Reference existing ECS cluster
data "aws_ecs_cluster" "my_app_cluster" {
  cluster_name = "my-app-cluster" 
}

resource "aws_ecs_task_definition" "my_app" {
  family                   = "my-app-task-yy"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "my-app"
    image     = "${data.aws_ecr_repository.my_app.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8000
      hostPort      = 8000
    }]
  }])
}

resource "aws_ecs_service" "my_app" {
  name            = "my-app-service-xy"
  cluster         = data.aws_ecs_cluster.my_app_cluster.id
  task_definition = aws_ecs_task_definition.my_app.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-0dbcc75f8ab359175"] 
    security_groups = ["sg-01c0dead894195c58"] 
  }

  desired_count = 1
}
