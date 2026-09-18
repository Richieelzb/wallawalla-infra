resource "aws_ssm_parameter" "db_host" {
  name  = "/wallawalla/prod/db-host"
  type  = "String"
  value = "wallawalla-postgres.cng64mu8ka2f.eu-west-1.rds.amazonaws.com:5432"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/wallawalla/prod/db-password"
  type  = "SecureString"
  value = "2026Certifiedkubernetes*"
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/wallawalla/prod/db-port"
  type  = "String"
  value = "5432"
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/wallawalla/prod/db-name"
  type  = "String"
  value = "appdb"
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/wallawalla/prod/db-user"
  type  = "String"
  value = "postgresadmin"
}

resource "aws_ssm_parameter" "flask_secret" {
  name  = "/wallawalla/prod/flask-secret-key"
  type  = "SecureString"
  value = "Pm&LmeFbsEb2"
}

resource "aws_ssm_parameter" "google_maps_key" {
  name  = "/wallawalla/prod/google-maps-api-key"
  type  = "SecureString"
  value = "AIzaSyDgjmJ5NfjJ1Q9R_g5zhlZiNlYF6aaq_d0"
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/wallawalla/prod/s3-bucket-name"
  type  = "String"
  value = "wallawalla-images"
}

resource "aws_ssm_parameter" "cognito_pool_id" {
  name  = "/wallawalla/prod/cognito-user-pool-id"
  type  = "String"
  value = "eu-west-1_j3pCX6WNm"
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "/wallawalla/prod/cognito-client-id"
  type  = "SecureString"
  value = "1fd7kcs92j342mjas42e3hmbvt"
}

resource "aws_ssm_parameter" "ses_region" {
  name  = "/wallawalla/prod/ses-region"
  type  = "String"
  value = "eu-west-1"
}

resource "aws_ssm_parameter" "payfast-id" {
  name  = "/wallawalla/prod/payfast_merchant_id"
  type  = "String"
  value = "37052225"
}
resource "aws_ssm_parameter" "payfast-key" {
  name  = "/wallawalla/prod/payfast_merchant_key"
  type  = "String"
  value = "0jgieer4onuwa"
}
resource "aws_ssm_parameter" "payfast-passphrase" {
  name  = "/wallawalla/prod/payfast_passphrase"
  type  = "String"
  value = "2026Certifiedkubernetes"
}
resource "aws_ssm_parameter" "payfast-sandbox" {
  name  = "/wallawalla/prod/payfast_sandbox"
  type  = "String"
  value = "false"
}