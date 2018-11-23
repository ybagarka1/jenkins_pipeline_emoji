# Infrastructre as code using Azure + Terraform

Pre-requisites:

1.  Install terraform on the desired server e.g. local server
2.  Configure terraform to use Azure(Refer Azure Docs to create the required parameters using Azure Cloud Shell.
3.  Create a simple shell script e.g. azure_params.sh to source the variable that terraform needs


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
  
  
  
