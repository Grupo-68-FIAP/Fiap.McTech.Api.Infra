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

  generate_secret     = false
  explicit_auth_flows = ["USER_PASSWORD_AUTH"]

  callback_urls                        = ["https://example.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "mctech_cg_domain" {
  domain       = "mctech-cg-domain"
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

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.node-group,
    aws_cognito_user_pool.mctech_cg,
    aws_cognito_user_pool_client.mctech_cg_client,
  ]
}
