resource "aws_ses_domain_identity" "wallawalla" {
  domain = "wallawalla.co.za"
}

resource "aws_ses_domain_identity_verification" "wallawalla" {
  depends_on = [aws_route53_record.ses_verification]
  domain     = aws_ses_domain_identity.wallawalla.domain
}

resource "aws_ses_domain_dkim" "wallawalla" {
  domain = aws_ses_domain_identity.wallawalla.domain
}