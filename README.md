# ACS730 Project
Welcome to the repository for our Group 2 final project in ACS730.

Group name: Group2  
Course:     ACS730  
Section:    Final Project  
Date:       04/14/2024  
Professor:  Leo Lu  

## User Mappings
Santosh Aryal  - Santosh Aryal   
Sirsha     - Sirsha Thapa  
Badder  -  Bader Sabbah
Saurav Chapagain - Saurav Chapagain   


## Infrastructure 

There will be 4 EC2 instances (Webservers) implemented in 4 public subnets across 4 availability zones, and other 2 EC2 instances (private instances) will be provisioned in 2 different private subnets across 2 availability zones.  
Internet Users can access to these 4 webservers through http protocol on port 80. In addition, administrators should be able to manage these webservers through SSH on port 22.  


## Deployment via Terraform

This section outlines the steps to deploy or delete AWS resources for this project using Terraform.

### Prerequisites
- Terraform installed on your system.
- Git installed on your system.
- Pre-create an S3 bucket in AWS for stroing Terraform state files.
- We upload the pictures of cats and dogs into our S3 bucket and modify the link in the index.html applied via user data file.

### Steps for Deployment and Deletion

**Clone the Repository**  
``git clone https://github.com/sauravchapagain/final-project-g2
``cd final-project-g2``
   
### Run the Deployment Script  
Go to the desired environment (like, dev, prod, staging) folder 

  The first step is deploying its networks as:
  1. cd final-project-g2/vpc_envs/dev/network
  2. terraform init
  3. terraform fmt
  4. terraform plan
  5. terraform apply

  The second step is deploying its web server as: 
  1. cd final-project-g2/vpc_envs/dev/webserver
  2. ssh-keygen -t rsa -f "finalproject" //to generate the public key
  3. terraform init
  4. terraform fmt
  5. terraform plan
  6. terraform apply

The last step for the environemtn is deploying its loadbalancer and autoscaling group:
  1. cd final-project-g2/vpc_envs/dev/lb
  2. terraform init
  3. terraform fmt
  4. terraform plan
  5. terraform apply
