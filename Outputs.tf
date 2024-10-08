output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.eks-cluster.name
}

output "user_pool_endpoint" {
  value = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.mctech_cg.id}"
}

output "opneid_config_url" {
  value = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.mctech_cg.id}/.well-known/openid-configuration"
}

# output "login_url" {
#   value       = "https://${aws_cognito_user_pool_domain.mctech_cg_domain.domain}.auth.${var.aws_region}.amazoncognito.com/login?response_type=code&client_id=${aws_cognito_user_pool_client.mctech_cg_client.id}&redirect_uri=https://example.com/"
#   description = "URL para a tela de login do Cognito"
# }

output "mctechapi_svc_address" {
  value = kubernetes_service.mctechapi-svc.status[0].load_balancer[0].ingress[0].hostname
}