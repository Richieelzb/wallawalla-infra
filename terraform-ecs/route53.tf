resource "aws_route53_record" "homepage" {
  zone_id = var.zone_id
  name    = "wallawalla.co.za"
  type    = "A"

  alias {
    name                   = aws_lb.main-alb.dns_name
    zone_id                = aws_lb.main-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "homepage-www" {
  zone_id = var.zone_id
  name    = "www.wallawalla.co.za"
  type    = "A"

  alias {
    name                   = aws_lb.main-alb.dns_name
    zone_id                = aws_lb.main-alb.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "epl" {
  zone_id = var.zone_id
  name    = "owner.wallawalla.co.za"
  type    = "A"

  alias {
    name                   = aws_lb.main-alb.dns_name
    zone_id                = aws_lb.main-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ses_verification" {
  zone_id = var.zone_id

  name = "_amazonses.wallawalla.co.za"
  type = "TXT"
  ttl  = 600

  records = [
    aws_ses_domain_identity.wallawalla.verification_token
  ]
}

resource "aws_route53_record" "dkim" {
  count = 3

  zone_id = var.zone_id

  name = "${aws_ses_domain_dkim.wallawalla.dkim_tokens[count.index]}._domainkey.wallawalla.co.za"

  type = "CNAME"
  ttl  = 600

  records = [
    "${aws_ses_domain_dkim.wallawalla.dkim_tokens[count.index]}.dkim.amazonses.com"
  ]
}

# resource "aws_route53_record" "root_txt" {
#   zone_id = var.zone_id

#   name = "wallawalla.co.za"
#   type = "TXT"
#   ttl  = 300

#   records = [
#     "v=spf1 include:secureserver.net include:amazonses.com -all",
#     "T3101055"
#   ]
# }
resource "aws_route53_record" "godaddy_email" {
  zone_id = var.zone_id

  name = "email.wallawalla.co.za"
  type = "CNAME"
  ttl  = 300

  records = [
    "email.secureserver.net"
  ]
}

resource "aws_route53_record" "godaddy_dkim_1" {
  zone_id = var.zone_id

  name = "secureserver1._domainkey.wallawalla.co.za"
  type = "CNAME"
  ttl  = 300

  records = [
    "s1.dkim.wallawalla_co_za.bc0.onsecureserver.net"
  ]
}

resource "aws_route53_record" "godaddy_dkim_2" {
  zone_id = var.zone_id

  name = "secureserver2._domainkey.wallawalla.co.za"
  type = "CNAME"
  ttl  = 300

  records = [
    "s2.dkim.wallawalla_co_za.bc0.onsecureserver.net"
  ]
}

resource "aws_route53_record" "autodiscover" {
  zone_id = var.zone_id

  name = "_autodiscover._tcp.wallawalla.co.za"
  type = "SRV"
  ttl  = 300

  records = [
    "100 1 443 autodiscover.secureserver.net"
  ]
}

resource "aws_route53_record" "spf" {
  zone_id = var.zone_id

  name = "wallawalla.co.za"
  type = "TXT"
  ttl  = 300

  records = [
    # "D4602833",
    "T3101055",
    "v=spf1 include:secureserver.net include:amazonses.com -all"
  ]
}


resource "aws_route53_record" "dmarc" {
  zone_id = var.zone_id

  name = "_dmarc.wallawalla.co.za"
  type = "TXT"
  ttl  = 300

  records = [
    "v=DMARC1; p=reject; rua=mailto:dmarc_rua@onsecureserver.net; adkim=r; aspf=r;"
  ]
}

resource "aws_route53_record" "mx" {
  zone_id = var.zone_id
  name    = "wallawalla.co.za"
  type    = "MX"
  ttl     = 300

  records = [
    "0 smtp.secureserver.net",
    "10 mailstore1.secureserver.net"
  ]
}
