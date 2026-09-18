resource "aws_cognito_user_pool" "wallawalla" {
  name = "WallawallaUserPool"

  # Users sign in with email
  username_attributes = ["email"]

  # Email is required
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }

  # MFA Optional
  mfa_configuration = "OFF"

  # Password Policy
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_uppercase                = true
    require_numbers                  = true
    require_symbols                  = false
    temporary_password_validity_days = 7
  }

  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = {
    Name        = "WallawallaUserPool"
    Environment = "dev"
  }
}

resource "aws_cognito_user_pool_client" "wallawalla_client" {
  name         = "WallawallaAppClient"
  user_pool_id = aws_cognito_user_pool.wallawalla.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    # "ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"
}