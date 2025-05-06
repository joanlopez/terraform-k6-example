terraform {
  cloud {
    organization = "joanjan14"
    workspaces {
      name = "terraform-k6-example"
    }
  }
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 3.24.0, < 4.0.0"
    }
  }
}

provider "grafana" {
  alias                     = "cloud"
  cloud_access_policy_token = var.gc_access_policy_token
}

/* The stack already exists
resource "grafana_cloud_stack" "k6_tf_demo" {
  provider = grafana.cloud

  name        = "k6tfdemo.grafana.net"
  slug        = "k6tfdemo"
  region_slug = "us"
}
 */

data "grafana_cloud_stack" "k6_tf_demo" {
  provider = grafana.cloud

  slug = "k6tfdemo"
}


resource "grafana_cloud_stack_service_account" "k6_tf_demo_k6app_sa" {
  provider   = grafana.cloud
  stack_slug = data.grafana_cloud_stack.k6_tf_demo.slug

  name        = "k6_tf_demo_k6app_sa"
  role        = "Admin"
  is_disabled = false
}

resource "grafana_cloud_stack_service_account_token" "k6_tf_demo_k6app_sa_token" {
  provider   = grafana.cloud
  stack_slug = data.grafana_cloud_stack.k6_tf_demo.slug

  name               = "k6_tf_demo_k6app_sa_token"
  service_account_id = grafana_cloud_stack_service_account.k6_tf_demo_k6app_sa.id
}

resource "grafana_k6_installation" "k6_tf_demo_k6_installation" {
  provider = grafana.cloud

  cloud_access_policy_token = var.gc_access_policy_token
  stack_id                  = data.grafana_cloud_stack.k6_tf_demo.id
  grafana_sa_token          = grafana_cloud_stack_service_account_token.k6_tf_demo_k6app_sa_token.key
  grafana_user              = "admin"
}

provider "grafana" {
  alias = "k6"

  stack_id        = data.grafana_cloud_stack.k6_tf_demo.id
  k6_access_token = grafana_k6_installation.k6_tf_demo_k6_installation.k6_access_token
}

resource "grafana_k6_project" "k6_tf_demo_k6_project" {
  provider = grafana.k6

  name = "Terraform k6 example"
}
