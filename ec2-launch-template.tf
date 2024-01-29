# Configuring an EC2 launch template
resource "aws_launch_template" "ec2_lt" {
  name_prefix = "ecs-template"
  image_id = "ami-0c45946ade6066f3d"  # AMI otimizada para ECS

  instance_type = "t2.micro"

  key_name               = "humangov-ec2-key"
#  vpc_security_group_ids = ["sg-0a8a5d047e1e9e212"] # SG default
  vpc_security_group_ids = [aws_security_group.security_group.id]
  iam_instance_profile {
    name = "ecsInstanceRole" # it's a predefined role available in all AWS accounts
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "esc_instance"
    }
  }
  user_data = filebase64("${path.module}/ecs.sh")
}