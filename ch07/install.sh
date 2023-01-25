#!/bin/bash

# install python3 and pip3
sudo apt install python3 python3-pip python3-dev curl wget jq unzip  docker-compose -y

# install some pip3 modules
#   install docker-compose v 2.x
sudo curl -fL https://raw.githubusercontent.com/docker/compose-switch/master/install_on_linux.sh | sh

# install localstack
#python3 -m pip install localstack


# install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


# install awscli-local
pip3 install awscli-local

# Use the AWS SAM (Serverless Application Model) with LocalStack
# https://docs.localstack.cloud/user-guide/integrations/aws-sam/
pip3 install aws-sam-cli-local

# for aws lamda for java
sudo apt install --yes --no-install-recommends openjdk-11-jdk  maven



# start localstack in docker
# localstack start

# start localstack locally
# localstack start --host
# export LAMBDA_DOCKER_FLAGS='-p *:5005:5005'
# export LAMBDA_JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005:5005