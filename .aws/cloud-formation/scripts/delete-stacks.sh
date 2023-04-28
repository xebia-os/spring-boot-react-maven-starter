#!/bin/bash
set -ex

ENV_NAME_ARG=$1

MAIN_STACK_NAME=${ENV_NAME_ARG}
ECR_STACK_NAME=${ENV_NAME_ARG}-ecr
TEMPLATE_STORAGE_STACK_NAME=${ENV_NAME_ARG}-template-storage

###############################################################################
# Delete the S3 bucket used to store Cloud Formation templates. Cloud Formation
# won't delete a stack which provisioned an S3 bucket which is non-empty - so
# this must happen first.
#

if aws s3 ls s3://${ENV_NAME_ARG}; then
    aws s3 rb s3://${ENV_NAME_ARG} --force || true
fi


###############################################################################
# Delete the ECR which holds our application's images. This must happen before
# the stack which provisioned the ECR is deleted.
#

if aws ecr describe-repositories --repository-names ${ENV_NAME_ARG}; then
    aws ecr delete-repository --repository-name ${ENV_NAME_ARG} --force || true
fi


###############################################################################
# Delete all the stacks we've created.
#

if aws cloudformation describe-stacks --stack-name ${ECR_STACK_NAME}; then
    aws cloudformation delete-stack --stack-name ${ECR_STACK_NAME} || true
    aws cloudformation wait stack-delete-complete --stack-name ${ECR_STACK_NAME}
fi

if aws cloudformation describe-stacks --stack-name ${TEMPLATE_STORAGE_STACK_NAME}; then
    aws cloudformation delete-stack --stack-name ${TEMPLATE_STORAGE_STACK_NAME} || true
    aws cloudformation wait stack-delete-complete --stack-name ${TEMPLATE_STORAGE_STACK_NAME}
fi

if aws cloudformation describe-stacks --stack-name ${MAIN_STACK_NAME}; then
    aws cloudformation delete-stack --stack-name ${MAIN_STACK_NAME} || true
    aws cloudformation wait stack-delete-complete --stack-name ${MAIN_STACK_NAME}
fi

echo "$(date):create:${ENV_NAME_ARG}:success"
