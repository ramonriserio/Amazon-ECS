# Defina uma VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        name = "main"
    }
}

# Adicione duas subredes à VPC criada
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.main.id
#    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.main.id
#    cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8 , 2)
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
}

# Crie um internet gateway para a VPC
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "internet_gateway"
    }
}

# Crie uma route table e associe-a às subredes criadas
resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "subnet_route" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.route_table.id
}

# Crie um security group junto com regras de entrada e saída
resource "aws_security_group" "security_group" {
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = "false"
        cidr_blocks = [ "0.0.0.0/0" ]
        description =  "any"
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}