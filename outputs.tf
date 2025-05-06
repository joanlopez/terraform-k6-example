output "cloud_stack_id" {
  value = data.grafana_cloud_stack.k6_tf_demo.id
}

output "k6_project_id" {
  value = grafana_k6_project.k6_tf_demo_k6_project.id
}