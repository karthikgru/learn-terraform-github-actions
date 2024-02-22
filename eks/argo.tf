data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                       = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate     = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "argocd" {
  name                = "argocd"
  repository          = "https://argoproj.github.io/argo-helm"
  chart               = "argo-cd"
  namespace           = "argocd"
  create_namespace    = true
  version             = "3.35.4"
  values = [
    file("values/argocd.yaml"),
    yamlencode({
      server: {
        service: {
          type: "LoadBalancer"
          annotations: {
            "service.beta.kubernetes.io/aws-load-balancer-type": "alb"
            "service.beta.kubernetes.io/aws-load-balancer-scheme": "internet-facing"
          }
        }
        ingress: {
          enabled: true
          annotations: {
            "kubernetes.io/ingress.class": "alb"
            "alb.ingress.kubernetes.io/scheme": "internet-facing"
          }
          tls: []
        }
      }
    })
  ]
}



