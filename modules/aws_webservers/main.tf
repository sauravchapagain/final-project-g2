provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "terraform_remote_state" "get_network_data" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-group2-project"               // Bucket from where to GET Terraform State
    key    = "dev/network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                          // Region where bucket created
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Provision WebServers in public subnets
resource "aws_instance" "ec2_instances_webservers" {
  count                       = length(data.terraform_remote_state.get_network_data.outputs.public_subnet_ids)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.proj_key.key_name
  subnet_id                   = data.terraform_remote_state.get_network_data.outputs.public_subnet_ids[count.index]
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data = file("install_httpd.sh")

 # user_data                   = var.env == "nonprod" ? file("../../nonprod/webservers/install_httpd.sh") : null

  tags = merge(var.default_tags,
    {
      #"Name" = "${var.prefix}-WebServers-${count.index + 1} "
      "Name" = "${var.prefix}-WebServers-${count.index + 1}"
      # "Ansible" = count.index < 2 ? null : "Yes"
    }
  )
}

# Provision VMs in private subnets
resource "aws_instance" "ec2_instances_private_vms" {
  count                       = length(data.terraform_remote_state.get_network_data.outputs.private_subnet_id)
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.proj_key.key_name
  subnet_id                   = data.terraform_remote_state.get_network_data.outputs.private_subnet_id[count.index]
  security_groups             = [aws_security_group.private_vm_sg.id]
  associate_public_ip_address = false
  
  user_data = file("install_httpd.sh")
    # {
    #   env    = upper(var.env),
    #   prefix = upper(var.prefix)
    # }
  
 #user_data                   = file("../../prod/webservers/install_httpd.sh")
 # user_data                   = var.env == "nonprod" ? file("../../nonprod/webservers/install_httpd.sh") : null

  tags = merge(var.default_tags,
    {
      "Name" = "${var.prefix}-EC2-${count.index + 1}-VM"
    }
  )
}

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "proj_key" {
  key_name   = "proj_key"
  public_key = file(var.path_to_linux_key)
}

# Define a launch configuration for the Auto Scaling Group
resource "aws_launch_configuration" "web_server_launch_config" {
  name                        = "${var.prefix}-web-server-lc"
  image_id                    = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.proj_key.key_name
  security_groups             = [aws_security_group.web_sg.id]
  user_data                   = file("install_httpd.sh")  # Path to your user data script
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

# Define the autoscaling group
resource "aws_autoscaling_group" "web_server_asg" {
  name                      = "${var.prefix}-web-server-asg"
  launch_configuration      = aws_launch_configuration.web_server_launch_config.name
  min_size                  = 2  # Adjust as needed
  max_size                  = 6  # Adjust as needed
  desired_capacity          = 2  # Adjust as needed
  vpc_zone_identifier       = data.terraform_remote_state.get_network_data.outputs.public_subnet_ids
  health_check_type         = "EC2"
  health_check_grace_period = 300  # Adjust as needed

  tag {
    key                 = "Name"
    value               = "${var.prefix}-web-server-scaled"
    propagate_at_launch = true
  }
}

# Define the autoscaling policy
resource "aws_autoscaling_policy" "web_server_scaling_policy" {
  name                   = "${var.prefix}-scale-out"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "PercentChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_server_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 5 # CPU utilization threshold in percentage
  }
}