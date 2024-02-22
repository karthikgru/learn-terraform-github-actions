# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args = [
#       "eks",
#       "get-token",
#       "--cluster-name",
#       data.aws_eks_cluster.cluster.name
#     ]
#   }
# }

# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name = "long-live-the-bat"
#     labels = {
#       App = "LongLiveTheBat"
#     }
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         App = "LongLiveTheBat"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           App = "LongLiveTheBat"
#         }
#       }
#       spec {
#         container {
#           image = "nginx:1.7.8"
#           name  = "batman"

#           port {
#             container_port = 80
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }