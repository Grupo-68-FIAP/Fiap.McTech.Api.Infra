resource "aws_cognito_user_pool" "mctech_cg" {
  name = "mctech_cg"

  schema {
    name                = "preferred_username"
    attribute_data_type = "String"
    mutable             = true
    required            = true
  }

  alias_attributes         = []
  auto_verified_attributes = []
}

resource "aws_cognito_user_pool_client" "mctech_cg_client" {
  name         = "mctech_cg_client"
  user_pool_id = aws_cognito_user_pool.mctech_cg.id
}

resource "kubernetes_secret" "cognito_secrets" {
  metadata {
    name = "cognito-secrets"
  }

  data = {
    OPENID_AUTHORITY = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.mctech_cg.id}"
    OPENID_AUDIENCE  = aws_cognito_user_pool_client.mctech_cg_client.id
  }
}
