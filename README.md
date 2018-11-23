# Infrastructre as code using Azure + Terraform

Pre-requisites:

1.  Install terraform.
2.  Configure terraform to use Azure (Refer Azure Docs to create the required parameters using Azure Cloud Shell).
3.  Create a simple shell script that will act as a source e.g. azure_params.sh.

Instructions on usage:
1. create a directory named jenkins_vm_terraform.
2. copy the jenkins_vm.tf into the above directory.
3. run cmd: terraform init --> this will ensure terraform has the required plugins as per vendor installed.
4. run cmd: terraform plan --> this will give us the info of the changes terraform will make on the azure
5. run cmd: terraform apply -auto-approve --> this will start the actual execution of the .tf script to spwan different resources in azure required for running a virtual machine.

# jenkins.tf 
1. will create resource group, virtual network, subnets, security groups, port configuration etc.
2. the most important is the custom installation of packages post re-boot. the optional "custom_data" under os_profile will execute the file customdata.txt.
3. the customdata.txt is a configuration file passed to cloud-init in azure this file acts as an instructions to install third party packages post instance boot.


# Jenkins Pipeline Emoji

# Jenkins Infrastructure
  
  Jenkins is hosted on Azure Ubuntu 16.04 as a container with docker and npm tools installed along with basic plugins of jenkins.

# Basic Jenkinsfile to create a CI/CD for npm projects using docker

The Jenkinsfile will perform the below steps:

  1. scm checkout 
  2. npm install --> build using a docker file to create images with tag $JOB_NAME:$JOB_NAME_v_$BUILD_NUMBER
  3. static code analysis
  3. push the image to the docker registry --> for versioning
  4. stop the container, remove the container and create a container with new image --> shell script
  
# Enhacements

  1. the Jenkinsfile should be checked in the git repo as a template with variables source from a file specific to the git project
  2. static anaylsis on the npm project 
  3. break the build in case the analysis threshold is breached
  4. upload new images to the docker registry
  5. use of kubernetes to deploy the latest build image in a rolling update fashion for HA
  
  
  
