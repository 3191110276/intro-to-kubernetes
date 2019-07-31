#!/bin/bash

# Ask the user for information about their environment
echo Hello, help us with the setup by providing some information about your environment

read -p 'Pod number: ' pod_number
read -p 'Pod password: ' pod_password

echo $pod_number
echo $pod_password

curl -o auto_deploy.sh \
  https://raw.githubusercontent.com/3191110276/intro-to-kubernetes/master/0_Environment_Setup/setup/auto_deploy.sh \
  && chmod +x auto_deploy.sh

./auto_deploy.sh $pod_number $pod_password full

rm auto_deploy.sh
rm auto_deploy.log
