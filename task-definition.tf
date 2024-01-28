# Create ECS Task Definition/Template
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "webapp"
  network_mode       = "awsvpc"
  execution_role_arn = "arn:aws:iam::684644783255:role/ecsTaskExecutionRole"
  cpu                = 1024 # equivale a 1 vCPU - QUANTIDADE DE CPU A SER ALOCADA PARA A ECS 
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  
  container_definitions = jsonencode([{
    name      = "webapp-ctr"
    image     = "strm/helloworld-http" # image URL of the application image
    cpu       = 1024                    # equivale a 1 vCPU - QUANTIDADE DE CPU A SER ALOCADA PARA A ECS 
    memory    = 256                     # 256 MiB = 0.25 GiB
    essencial = true                    # a execução do container é essencial para a tarefa
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}