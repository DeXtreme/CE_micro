# CE_micro
Azubi week 15 assignment: Microservice makeover

## Problem Statement: 
Create a simple microservices application using AWS containers. The application consists of two microservices: a front-end that displays inspirational quotes and a back-end that provides quote data.

## Guidelines/Goals:

### Containerize Microservices:
Create a Docker container for the front-end and backend servers  using a basic HTML page.

### Set Up ECS Cluster:
- Create an Amazon ECS cluster to manage your microservices.
- Define task definitions for each microservice, specifying the container images and ports.

### Deploy Microservices:
- Launch your microservices as ECS services within the cluster.
- Configure an Application Load Balancer to distribute traffic to the front-end microservice.


## Usage

1. Clone the repo
2. Initialize terraform
    ```
    terraform init
    ```
3. Apply the configuration and enter the required variables
    ```
    terraform apply
    ```
