# Example: Terraform + k6 + GitHub Actions

This repository provides a simple, end-to-end example of how to use
[Terraform](https://developer.hashicorp.com/terraform) to manage [Grafana Cloud](https://grafana.com/products/cloud/)
resources — including k6 projects and load tests — and how to use the
[`setup-k6-action`](https://github.com/grafana/setup-k6-action) and
[`run-k6-action`](https://github.com/grafana/run-k6-action) GitHub Actions to run load tests in CI workflows.

## Requirements

### Tools

- [k6](https://grafana.com/oss/k6/)
- [Terraform](https://developer.hashicorp.com/terraform)
- k6 GitHub Actions:
    - [setup-k6-action](https://github.com/grafana/setup-k6-action)
    - [run-k6-action](https://github.com/grafana/run-k6-action)

### Services

- [Grafana Cloud k6](https://grafana.com/products/cloud/k6/)
- [GitHub Pages](https://pages.github.com/) (*or any other web host*)
- Terraform backend (*e.g., [Terraform Cloud](https://www.hashicorp.com/es/products/terraform) or your preferred state
  management system*)

## How it works

This example demonstrates:

- Hosting a simple HTML page via GitHub Pages: [index.html](./index.html)
- Running a browser-based k6 test: [script.js](./script.js)
- Managing infrastructure with Terraform ([main.tf](./main.tf)), including:
    - Creating a k6 project in Grafana Cloud
    - Registering a load test

### Workflow overview

On every push to `main`:

1. GitHub Pages deploys the `index.html`.
2. Terraform runs:
    - `terraform init`
    - `terraform plan`
    - `terraform apply -auto-approve`
3. A k6 test is triggered, using the project created by Terraform.

## Additional notes

### Terraform module

#### Uses an existing Grafana Cloud stack

This example uses the
[
`grafana_cloud_stack` data source](https://registry.terraform.io/providers/grafana/grafana/latest/docs/data-sources/cloud_stack),
assuming a pre-existing stack. You can optionally use the [
`grafana_cloud_stack` resource](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/cloud_stack)
to provision a new stack.

Likewise, you can retrieve existing projects via [
`grafana_k6_project` data source](https://registry.terraform.io/providers/grafana/grafana/latest/docs/data-sources/k6_project),
or create new ones using the resource (_as in the example)_.

#### The use of the `grafana_k6_installation` resource is optional

If you already have a stack, you plan to create a new stack with the k6 App enabled on it, or you plan to enable the
k6 App manually, you don't really need the
[
`grafana_k6_installation` resource](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/k6_installation).

Alternatively, you can provide the `k6_access_token` as a variable, for instance.

#### Multiple Grafana provider blocks

The Terraform module in this example ([main.tf](./main.tf)) uses two `grafana` providers with different aliases:

- One for stack and service account management
- One for managing k6-specific resources

If your token and stack setup already cover both use cases, you can simplify to a single provider.

## Future work

### Support for Scheduled load tests

A great addition to this example repository could be to manage some "Schedules", which are "scheduled" load tests
(similarly to cron jobs) through the Terraform module. 

However, the
[Grafana k6 REST API](https://grafana.com/docs/grafana-cloud/testing/k6/reference/cloud-rest-api/) does not support
managing Schedules programmatically, so this remains a future enhancement.

## Contributing

Contributions are welcome!

Feel free to [open an issue](https://github.com/joanlopez/terraform-k6-example/issues/new) or
[submit a pull request](https://github.com/joanlopez/terraform-k6-example/compare).