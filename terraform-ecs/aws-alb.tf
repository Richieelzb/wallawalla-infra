resource "aws_lb" "main-alb" {
  name               = "main-alb-project"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-sg.id]
  subnets            = module.vpc.public_subnets[*]
}



resource "aws_lb_target_group" "main-tg" {
  name        = "main-alb-targets"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb_target_group" "owner-tg" {
  name                 = "owner-alb-targets"
  port                 = 5000
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = "30"
  vpc_id               = module.vpc.vpc_id
}

resource "aws_lb_listener" "main-listener" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate_validation.lzb-certificate.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-tg.arn
  }
}

resource "aws_lb_listener_rule" "owner" {

  listener_arn = aws_lb_listener.main-listener.arn

  priority = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.owner-tg.arn
  }

  condition {
    host_header {
      values = ["owner.wallawalla.co.za"]
    }
  }
}


resource "aws_lb_listener" "http-redirect-main" {
  load_balancer_arn = aws_lb.main-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}