resource "aws_elb" "rancher-server-external" {
  name                      = "${var.environment}-rancher-external"
  subnets                   = ["${split(",", var.rancher_servers_public_subnets_ids)}"]
  security_groups           = ["${split(",", var.rancher_servers_security_groups)}"]
  cross_zone_load_balancing = true
  internal                  = false

  listener {
    instance_port      = 81
    instance_protocol  = "tcp"
    lb_port            = 80
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 8080
    instance_protocol  = "tcp"
    lb_port            = 8080
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 444
    instance_protocol  = "tcp"
    lb_port            = 443
    lb_protocol        = "tcp"
  }

  listener {
    instance_port      = 18080
    instance_protocol  = "tcp"
    lb_port            = 18080
    lb_protocol        = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/ping"
    interval            = 30
  }

  instances                   = ["${aws_instance.rancher-servers.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.environment}-rancher"
  }
}

resource "aws_proxy_protocol_policy" "rancher-external" {
  load_balancer  = "${aws_elb.rancher-server-external.name}"
  instance_ports = ["81","444"]
}

resource "aws_route53_record" "rancher" {
  zone_id = "Z1TLA2WNUBIE2P"
  name    = "${var.rancher_url}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_elb.rancher-server-external.dns_name}"]
}
