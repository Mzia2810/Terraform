resource "aws_ecs_cluster" "main" {
  name = "dev-cluster"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/dev-app"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
  family                   = "dev-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = 256
  memory = 512

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.image_url
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/dev-app"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "dev-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 80
  }

  depends_on = [
    aws_ecs_task_definition.app
  ]
}