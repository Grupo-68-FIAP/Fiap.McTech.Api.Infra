variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Define a região padrão da AWS onde os recursos serão provisionados."
}

variable "project_name" {
  type        = string
  default     = "MechTechApi"
  description = "Especifica o nome do projeto"
}

variable "instanceType" {
  type        = string
  default     = "t3a.medium"
  description = "Especifica o tipo de instância EC2 que será utilizada, sendo uma instância de uso geral com equilíbrio entre capacidade de computação e custo."
}

variable "accountIdVoclabs" {
  type        = string
  description = "Representa o ID da conta da AWS para o laboratório vocacional. Esta variável é obrigatória."
}

variable "policyArn" {
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  description = "Define o Amazon Resource Name (ARN) de uma política específica que pode ser aplicada a recursos ou usuários. Esta variável é obrigatória."
}

variable "accessConfig" {
  type        = string
  default     = "API_AND_CONFIG_MAP"
  description = "Especifica a configuração de acesso desejada, incluindo tanto a API quanto um mapa de configuração."
}
