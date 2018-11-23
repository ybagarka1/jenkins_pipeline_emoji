#!/bin/bash
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export ARM_CLIENT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export ARM_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export ARM_TENANT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public

