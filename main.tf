provider "aws" {
  region = "ap-south-1"  # Specify your AWS region
}

resource "aws_ecr_repository" "my_app" {
  name = "my-app-repo"
}


resource "aws_ecs_cluster" "my_app_cluster" {
  name = "my-app-cluster"
}

resource "aws_ecs_task_definition" "my_app" {
  family                   = "my-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "my-app"
    image     = "${aws_ecr_repository.my_app.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8000
      hostPort      = 8000
    }]
  }])
}

resource "aws_ecs_service" "my_app" {
  name            = "my-app-service"
  cluster         = aws_ecs_cluster.my_app_cluster.id
  task_definition = aws_ecs_task_definition.my_app.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-0dbcc75f8ab359175"]  # Replace with your subnet IDs
    security_groups = ["sg-01c0dead894195c58"]  # Replace with your security group ID
  }

  desired_count = 1
}
