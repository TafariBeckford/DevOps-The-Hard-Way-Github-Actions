terraform {
  cloud {
    organization = "tafari"

    workspaces {
      name = "DevOps-The-Hard-Way-AWS-Infrastructure"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
      command     = "aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"

}


resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.4"

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.default.id
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

}


