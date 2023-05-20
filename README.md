# GCP Dev Environment

Why go bankrupt just to get a decent development environment? You don't need to pay for the latest MacBook Pro to get the RAM and CPU needed to run a TensorFlow model. All you need is an internet connection and an GCP account.

This is a guide to setting up a development environment on GCP. GCP offers free computing resources up to 300$ for the first year.

This will deploy an GCP Compute instance with an Ubuntu AMI and Docker ready to go.

## Instructions

1. Create an GCP account
2. Install the GCP CLI.
3. Install terraform and the GCP provider with `terraform init`.
4. Login to the GCP CLI with `gcloud auth application-default login`.
5. We'll be installing a simple Ubuntu image. If you want to change that image, use `gcloud compute images list` to get a list of available images.
6. Set the local environment variables by copying `example.tfvars` to a `terraform.tfvars` file.
7. Generate an SSH keypair with the `ssh-keygen -t ed25519 -f ~/.ssh/id_gcp_dev_environ` command for Linux or `ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_gcp_dev_environ"` . We will be calling it `id_gcp_dev_environ`.
8. Set your secrets in the `terraform.tfvars` file. Use the `example.tfvars` file as a template.
9. Deploy your GCP Dev environment with the following commands:
   1. `terraform init`
   2. `terraform plan`
   3. `terraform apply`
10. SSH into your newly created instance:
    1. Get the public ID address: `terraform output`
    2. SSH into the instance: `ssh -i "$env:USERPROFILE\.ssh\id_gcp_dev_environ" ubuntu@<public_ip>`

I've also added a local provisioner to the infrastructure configuration. If it runs correctly, you should be able to connect to the instance by installing the "Remote-SSH" plugin and then selecting the "Connect to Host" option.

## Terraform commands

Basic command cycle is:

`terraform init` -> `terraform plan` -> `terraform apply`

- **terraform fmt** - Formats the `.tf` files.
- **terraform show** - Shows the entire Terraform state or plan file in a human-readable
  form.
- **terraform state list** - List resources in the state.
- **terraform state show RESOURCE_NAME** - Show a resource in the state.
- **terraform destroy** - Destroy Terraform-managed infrastructure.
- **terraform plan -destroy** - Shows you what the destroy changes would be, without doing them.
- **terraform console** - Opens an interactive console for experimenting with Terraform interpolations.
- **terraform import** - Import existing infrastructure into Terraform.
- **terraform validate** - Validates the Terraform files.
- **terraform apply -auto-approve** - Apply changes without confirmation.
- **terraform plan -out=NAME** - Generate and save a plan file.
- **terraform apply NAME** - Apply a saved plan file.

## Infrastructure

### VPCs and Subnets

#### VPC

A VPC is essentially just a virtual network. It is isolated from resources located on other VPCs that you might create. When you create a VPC, you create it within a specific region. The VPC can service all of the availability zones within the region, but it cannot extend to other regions.

When you create a VPC, GCP asks you to associate a CIDR block with the VPC. CIDR is an acronym that stands for Classless Inter-Domain Routing. In simpler terms, a CIDR block is an IP address range. A VPC can accommodate two CIDR blocks, one for IPv4 and another for IPv6, but for the sake of simplicity we are going to talk about IPv4.

#### Subnets

A subnet is a range of IP addresses in your VPC. You can attach GCP resources, such as EC2 instances and RDS DB instances, to subnets. You can create subnets to group instances together according to your security and operational needs.

When you create a CIDR block, you must enter it as an IP address range. In the case of an IPv4 CIDR, this means entering a network prefix and a subnet mask. The subnet mask determines how many IP addresses can be created from the CIDR block. Amazon requires that a CIDR block include a subnet mask ranging from 16 to 28. The two most commonly used subnet sizes are 16 bits and 24 bits.

If you were to create a CIDR block with a 16-bit subnet, then the network portion of the IP address would contain two eight-bit numbers, followed by two zeros, each separated by periods. Here is an example of a CIDR block with a 16-bit subnet: **10.10.**0.0/16. This block would allow for the creation of up to 65,536 IP addresses. Each address would start with 10.10, but you can enter any value between 0 and 255 into the last two positions.

A CIDR block with a 24-bit address would contain three eight-bit numbers, followed by a single 0. Here is an example of what such a block would look like: **10.10.10**.0/24. This block could accommodate up to 256 IP addresses. The first three octets (10.10.10) would be common to each address, but the last digit can be populated with a number ranging between 0 and 255.

The key to understanding the way that subnetting works in GCP is to keep in mind that when you create a CIDR block, you are not actually creating any subnets. Subnets have to be created separately and must fall within the range of the CIDR block. It's perfectly acceptable to create a single subnet that consumes the entire CIDR block (just use the same range when defining the VPC), but you also have the option of dividing the block into multiple subnets as is often done with very large CIDR blocks.

### Internet Getaway

A gateway is what allows a VPC to communicate with the internet.

### Route tables

Table tables allow to route traffic from the subnet to our internet getaway. It contains a set of rules, called routes, that determine where network traffic from your subnet or gateway is directed.

Each subnet in your VPC must be associated with a route table. You can explicitly associate a subnet with a particular route table. A subnet can only be associated with one route table at a time, but you can associate multiple subnets with the same subnet route table.

### Key Pairs

Key pairs are used to authenticate an EC2 instance. We will be using one so that we can SSH into the instance.
