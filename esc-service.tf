# Create the ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = "webapp-svc"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2 # we want to run 2 instances of the container image on our ECS cluster

  network_configuration {
    security_groups    = [aws_security_group.security_group.id]
    subnets = [
      aws_subnet.subnet.id,
      aws_subnet.subnet2.id
    ]
  }

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "webapp-ctr"
    container_port   = 80
  }

  depends_on = [
    aws_autoscaling_group.ecs_asg,
  ]
}