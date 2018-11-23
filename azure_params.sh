#!/bin/bash
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=9a5069b3-65e5-439c-8d79-4a81d7d40588
export ARM_CLIENT_ID=a710b04b-4adb-4305-bc4b-9de44a038365
export ARM_CLIENT_SECRET=135e1fb0-b8da-4941-9e5a-23b582c0422a
export ARM_TENANT_ID=767bf1f2-d80a-46d6-a212-bed0fb5d1e04

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public

