data "terraform_remote_state" "main_state" {
  backend = "remote"
  config = {
    organization = "demo-kk"
    workspaces = {
      name = "gh-actions-demo"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.main_state.outputs.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"
  values           = [file("values/argocd.yaml")]
}
# helm install argocd -n argocd -f values/argocd.yaml