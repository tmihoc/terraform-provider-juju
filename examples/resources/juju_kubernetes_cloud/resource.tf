resource "juju_kubernetes_cloud" "my-k8s-cloud" {
  name              = "my-k8s-cloud"
  kubernetes_config = file("<path-to-my-kubennetes-cloud-config>.yaml")
}