#!/bin/bash
set -ex

ENV_NAME_ARG=$1
GITHUB_USERNAME=$2
GITHUB_REPO=$3
GITHUB_BRANCH=$4
GITHUB_TOKEN=$5
CERTIFICATE_ARN=$6

###############################################################################
# Create an S3 stack which holds our CloudFormation templates and an ECR stack
# which will hold our application's Docker images
#

BUCKET_STACK_NAME=${ENV_NAME_ARG}-template-storage

if ! aws cloudformation describe-stacks --stack-name ${BUCKET_STACK_NAME}; then
  aws cloudformation deploy \
      --stack-name ${BUCKET_STACK_NAME} \
      --template-file ./.aws/cloud-formation/templates/template-storage.yml \
      --parameter-overrides BucketName=${ENV_NAME_ARG}
fi


###############################################################################
# Ensure that S3 has the most recent revision of our CloudFormation templates
#

aws s3 sync \
    --delete \
    ./.aws/cloud-formation/templates/ s3://${ENV_NAME_ARG}/infrastructure/cloud-formation/templates/


###############################################################################
# Create the stack
#

aws cloudformation deploy \
    --stack-name ${ENV_NAME_ARG} \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
    --template-file ./.aws/cloud-formation/templates/master.yml \
    --parameter-overrides \
        GitHubRepo=${GITHUB_REPO}\
        GitHubToken=${GITHUB_TOKEN} \
        GitHubUser=${GITHUB_USERNAME} \
        GitHubBranch=${GITHUB_BRANCH} \
        S3TemplateKeyPrefix=https://s3.amazonaws.com/${ENV_NAME_ARG}/infrastructure/cloud-formation/templates/ \
        CertificateArn=${CERTIFICATE_ARN}

echo "$(date):create:${ENV_NAME_ARG}:success"
