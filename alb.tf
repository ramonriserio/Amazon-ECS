# Configure the Application Load Balancer (ALB)
# (its listener, and the TARGET GROUP)
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets = [
    aws_subnet.subnet.id,
    aws_subnet.subnet2.id
  ]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "webapp-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
#  vpc_id      = "vpc-068827f882e554167" # VPC default (COMENTAR ESTA LINHA PRA VER O QUE ACONTECE)
  vpc_id      = aws_vpc.main.id # VPC default (COMENTAR ESTA LINHA PRA VER O QUE ACONTECE)

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward" # ecaminha tráfeto para o TARGET GROUP
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}