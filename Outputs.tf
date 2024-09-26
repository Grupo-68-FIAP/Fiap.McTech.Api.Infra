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

output "token_endpoint" {
  value = "https://${aws_cognito_user_pool_client.mctech_cg_client.id}.auth.${var.aws_region}.amazoncognito.com/oauth2/token"
}

output "authorize_endpoint" {
  value = "https://${aws_cognito_user_pool_client.mctech_cg_client.id}.auth.${var.aws_region}.amazoncognito.com/oauth2/authorize"
}

output "userinfo_endpoint" {
  value = "https://${aws_cognito_user_pool_client.mctech_cg_client.id}.auth.${var.aws_region}.amazoncognito.com/oauth2/userinfo"
}