# Configure the Application Load Balancer (ALB)
# (its listener, and the TARGET GROUP)
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0a8a5d047e1e9e212"] # Security Group default
  subnets = [                                   # default subnets (a, b, c, d, e, f)
    "subnet-06799c0492058fe7d",                 # us-east1-f
    "subnet-04a32a4d6929b00c6",
    "subnet-0f083690187814987",
    "subnet-07ebdb7d98ff6c3a2",
    "subnet-0b92ffe359f7875cd",
    "subnet-058e5931686efe405"
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
  vpc_id      = "vpc-068827f882e554167" # VPC default (COMENTAR ESTA LINHA PRA VER O QUE ACONTECE)

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