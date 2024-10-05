# NGINX Deployment on Docker Using Terraform

This guide will help you deploy an NGINX container on Docker locally using Terraform. It assumes you have Docker and Terraform installed on your machine.

Prerequisites
Before you begin, ensure you have the following installed:

Docker: [Install Docker](https://www.docker.com/products/docker-desktop/)\
Terraform: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Project Structure
```css
.
├── main.tf
└── README.md
```

### Steps to Deploy
1- Create main.tf file
In your project directory, create a file named main.tf with the following content: 

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "tcp://127.0.0.1:2375"
  #host = "unix:///var/run/docker.sock" # Docker on ubuntu connection
}

# Creating a Docker Image ubuntu with the latest as the Tag.
resource "docker_image" "ubuntu-latest" {
  name = "ubuntu:latest"
}

# Creating a Docker Container using the latest ubuntu image.
resource "docker_container" "webserver" {
  image             = docker_image.ubuntu-latest.name
  name              = "terraform-docker-test"
  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}

resource "docker_image" "nginx-latest" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx-latest.name
  name  = "nginx-dev"
  ports {
    internal = 80
    external = 9000
  }
}

resource "docker_network" "private_network" {
  name = "Moluwe"
}

resource "docker_volume" "shared_volume" {
  name = "elsa_volume"
}

```

This Terraform configuration does the following:

Defines the Docker provider.
Pulls the latest NGINX image from Docker Hub.
Runs the NGINX container and exposes it on port 8080 of your local machine.
Provide a network for 

2- Initialize Terraform
Run the following command to initialize Terraform and install the required provider plugins:
```bash
terraform init
```
3- Plan: Apply the plan command to see the strucure of the environment that would be provided:

```bash
terraform plan
```

4- Apply the Terraform Configuration
Once initialized, you can deploy NGINX by running:

```bash
terraform apply
```

You'll be prompted to confirm the deployment. Type yes to proceed.

4- Access NGINX
Once the deployment is successful, open your browser and go to http://localhost:8080. You should see the NGINX default welcome page.

5. Destroy the Deployment
To stop and remove the NGINX container, run the following command:
```bash
terraform destroy
```

Again, confirm the action by typing yes.

## Additional Information
- Provider Documentation: [Terraform Docker Provider](https://nginx.org/en/) 
- NGINX Documentation: [NGINX Official Website](https://spacelift.io/blog/terraform-docker)