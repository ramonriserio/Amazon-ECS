# Create an Auto Scaling Group (ASG)
# (and associate it with the lauch template created previously)
resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = [       # default subnets (a, b, c, d, e, f)
    "subnet-06799c0492058fe7d", # us-east1-f
    "subnet-04a32a4d6929b00c6",
    "subnet-0f083690187814987",
    "subnet-07ebdb7d98ff6c3a2",
    "subnet-0b92ffe359f7875cd",
    "subnet-058e5931686efe405"
  ]
  desired_capacity = 2
  max_size         = 2
  min_size         = 2
/*
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
*/
  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }
  
  tag {
    key = "AmazonECSManaged"
    value = true
    propagate_at_launch = true
  }
}