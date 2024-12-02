resource "aws_cognito_user_pool" "app_user_pool" {
  name = "AppUserPool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  tags = {
    Name = "AppUserPool"
  }
}

resource "aws_cognito_user_pool_client" "app_client" {
  name         = "AppUserPoolClient"
  user_pool_id = aws_cognito_user_pool.app_user_pool.id

  # No callback URLs since DNS is not used
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  generate_secret = false
}

resource "aws_cognito_user_pool_domain" "app_domain" {
  domain       = "app-userpool-${random_string.domain_suffix.result}"
  user_pool_id = aws_cognito_user_pool.app_user_pool.id
}

resource "random_string" "domain_suffix" {
  length  = 8
  special = false
  upper   = false
}
