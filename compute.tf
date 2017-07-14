data "aws_ami" "xenial" {
  most_recent = true
  filter {
    name = "name"
    values = ["*ubuntu-xenial-16.04-amd64-server*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = "${file("files/user-data.yml")}"
}

resource "aws_launch_configuration" "myproject-launch-conf" {
    image_id = "${data.aws_ami.xenial.id}"
    instance_type = "c4.large"
    iam_instance_profile = "myproject-role"           #TODO: provision
    key_name = "myproject-keypair"                    #TODO: provision
    ebs_optimized = true
    security_groups = "${var.vpc_security_groups}"
    user_data = "${data.template_file.user_data.rendered}"
    enable_monitoring = true
    root_block_device {
      volume_type = "gp2"
      volume_size = 100
    }
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "myproject-asg" {
    name = "${var.service}-${var.environment}-asg"
    launch_configuration = "${aws_launch_configuration.myproject-launch-conf.name}"

    max_size = 4
    min_size = 2
    desired_capacity = 2
    health_check_grace_period = 300
    health_check_type = "ELB"
    vpc_zone_identifier = "${var.subnet_ids}"
    load_balancers = ["${aws_elb.myproject-elb.name}"]
    tag {
      key = "environment"
      value = "${var.environment}"
      propagate_at_launch = true
    }
    tag {
      key = "service"
      value = "${var.service}"
      propagate_at_launch = true
    }
    tag {
      key = "team"
      value = "${var.team}"
      propagate_at_launch = true
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_elb" "myproject-elb" {
  name = "${var.service}-${var.environment}-elb"
  security_groups = "${var.vpc_security_groups}"
  subnets = "${var.subnet_ids}"
  internal = true
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  access_logs {
    bucket = "myproject-elb-accesslogs"
    bucket_prefix = "myproject"
    interval = 60
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/system/ping"               #TODO: configure
    interval = 30
  }
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300
  tags {
    Name = "${var.service}-${var.environment}-elb"
    environment = "${var.environment}"
    service = "${var.service}"
    team = "${var.team}"
  }
}
