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

# node should be a swarm manager. Use "docker swarm init" or "docker swarm join" to connect
#resource "docker_secret" "foo" {
#  name = "foo"
#  data = base64encode("{\"foo\": \"s3cr3t\"}")
#}

resource "docker_volume" "shared_volume" {
  name = "elsa_volume"
}

#The source image must exist on the machine running the docker daemon.
#resource "docker_tag" "tag" {
#  source_image = "xxxx"
#  target_image = "xxxx"
#}
