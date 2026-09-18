
output "alb_dns_name" {
  value = aws_lb.main-alb.dns_name
}

output "user_pool_id" {
  value = aws_cognito_user_pool.wallawalla.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.wallawalla_client.id
}

output "rds-endpoint" {
  value = aws_db_instance.postgres.endpoint
}