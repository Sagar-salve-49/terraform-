provider "aws" {
  region = "ap-south-1"
}

# -------------------------
# VPC & SUBNETS (DEFAULT)
# -------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"                             #Fetches the default VPC created by AWS.
    values = [data.aws_vpc.default.id]            #used default vpc id
  }
}

# -------------------------
# SECURITY GROUPS for alb
# -------------------------
resource "aws_security_group" "alb_sg" {             
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = data.aws_vpc.default.id           #Attach this SG to the default VPC

  ingress {
    from_port   = 80
    to_port     = 80                            # inbound rule
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                         # outbound rule
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {             # security for EC2 Instances
  name        = "instance-sg"
  description = "Allow ALB to reach EC2"
  vpc_id      = data.aws_vpc.default.id                   # Attach to default VPC

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# LOAD BALANCER
# -------------------------
resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false                                                   # false = Internet-facing ALB 
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]                         # Attach ALB security group.
  subnets            = data.aws_subnets.default.ids                          # ALB is placed in default VPC subnets
}

resource "aws_lb_target_group" "tg" {
  name     = "my-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id                                                  # TG belongs to the default VPC

  health_check {
    path = "/"                                                                       # ALB checks health by visiting /.
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn                                            # Attach listener to your ALB.
  port              = 80
  protocol          = "HTTP"

  default_action {                                                      # Define what ALB should do with incoming traffic.
    type             = "forward"                                        # Forward traffic.
    target_group_arn = aws_lb_target_group.tg.arn                       # Forward traffic to the target group.
  }
}

# -------------------------
# LAUNCH TEMPLATE
# -------------------------
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt"
  image_id      = "ami-02b8269d5e85954ef"                                          # change  AMI
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.instance_sg.id]                   # Assign EC2 security group.

  user_data = base64encode(<<EOF
#!/bin/bash
sudo yum install -y httpd
echo "Hello from AutoScaling Group!" > /var/www/html/index.html                 # script
sudo systemctl enable --now httpd
EOF
  )
}

# -------------------------
# AUTO SCALING GROUP
# -------------------------
resource "aws_autoscaling_group" "web_asg" {
  name                 = "web-asg"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 2
  health_check_type    = "EC2"
  vpc_zone_identifier  = data.aws_subnets.default.ids                  # Launch instances in all default subnets

  target_group_arns = [aws_lb_target_group.tg.arn]                     # Register instances with ALB target group

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"                                                # Always use latest version of launch template
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name          # Apply policy to your ASG
  adjustment_type        = "ChangeInCapacity"                          # Change number of instances
  scaling_adjustment     = 1                                           # Add 1 instance when scaling up
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name          # Attach to your ASG
  adjustment_type        = "ChangeInCapacity"                          # Change number of instances
  scaling_adjustment     = -1                                          # Remove 1 instance
}
