provider "aws" {
  region     = "us-east-1"  # Change to your preferred region
  access_key = ""  # Replace with your actual access key
  secret_key = ""  # Replace with your actual secret key
}


# Create VPC
resource "aws_vpc" "asg_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ASG"
  }
}

# Create two public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.asg_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a" # Update according to your region
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.asg_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b" # Update according to your region
  tags = {
    Name = "Public Subnet 2"
  }
}

# Create Internet Gateway and attach to VPC
resource "aws_internet_gateway" "asg_igw" {
  vpc_id = aws_vpc.asg_vpc.id
  tags = {
    Name = "ASG Internet Gateway"
  }
}

# Create route table for public subnets
resource "aws_route_table" "asg_public_rt" {
  vpc_id = aws_vpc.asg_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.asg_igw.id
  }
  tags = {
    Name = "ASG Public Route Table"
  }
}

# Associate route table with public subnets
resource "aws_route_table_association" "rt_assoc_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.asg_public_rt.id
}

resource "aws_route_table_association" "rt_assoc_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.asg_public_rt.id
}

# Create a Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.asg_vpc.id
  name   = "lb-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB Security Group"
  }
}

# Create a Security Group for EC2 Instances
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.asg_vpc.id
  name   = "instance-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For SSH access
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Instance Security Group"
  }
}

# Create an Application Load Balancer
resource "aws_lb" "asg_alb" {
  name               = "asg-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "ASG Load Balancer"
  }
}

# Create a Target Group
resource "aws_lb_target_group" "asg_tg" {
  name     = "MYTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.asg_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# Create a Listener for the Load Balancer
resource "aws_lb_listener" "asg_listener" {
  load_balancer_arn = aws_lb.asg_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}

# Create a Launch Template for Auto Scaling Group
resource "aws_launch_template" "asg_launch_template" {
  name          = "asg-launch-template"
  image_id      = "ami-0c55b159cbfafe1f0" # Replace with your desired AMI ID
  instance_type = "t2.micro"

  key_name = "your-key-name" # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance_sg.id]
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  health_check_type    = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.asg_tg.arn]

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Policies and CloudWatch Alarms (Optional, for Scaling Based on Load)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# CloudWatch Alarms for Auto Scaling (Optional)
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = "high-cpu"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_actions             = [aws_autoscaling_policy.scale_out.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name                = "low-cpu"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  alarm_actions             = [aws_autoscaling_policy.scale_in.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}
