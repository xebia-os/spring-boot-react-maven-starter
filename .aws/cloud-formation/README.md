# CloudFormation + ECS (Fargate) + RDS + CodePipeline + CloudWatch

![meow](https://user-images.githubusercontent.com/884507/34551896-a3a838a6-f0d2-11e7-8858-c4de887fb225.png)

## What's the Point?

The purpose of this repository is to provide the necessary tools for a
single-command provisioning of a high-availability, Fargate-backed ECS cluster
to which you can deploy your application. *The included templates and shell
scripts should be reviewed before you use them in a production environment.*

The provided Cloud Formation templates can easily be extended to support
multiple web services, to use some other web application framework, to use an
Auto Scaling Group controlled by CloudWatch, _et cetera_.

## What You'll Get

After successfully creating the Cloud Formation stack you'll have:

- a high-availability (multi-AZ) ECS cluster
- a load balancer routing requests to 2 instances (one in each AZ) of a Rails 5 application connected to an RDS Postgres database
- zero-downtime deploys to ECS via AWS Code Pipeline
- automatic application of cluster-safe migrations
- centralized logging with CloudWatch
- a human-readible (kinda) hostname (from the LB) at which you can point your web browser

## What You Won't Get

There are a few things deliberately omitted from this repository, namely:

- CertificateManager/SSL support
- Zone53/DNS integration

## Local Development

To run the application in development mode:

```sh
docker-compose -f ./websvc/docker-compose.yml up
```

then, verify that the application is accessible:

```sh
curl -v 'http://localhost:3333/posts'
```

## Deploying to AWS + CI

### 0. Prerequisites

- [Docker and Docker Compose](https://docs.docker.com/compose/)
- [AWS CLI](https://github.com/aws/aws-cli) version >= `1.14.11` configured to use the `us-east-1` as its default region (for Fargate support)
- [jq](https://github.com/stedolan/jq) version >= `jq-1.5`, for querying stack output-JSON
- an AWS [access key id and secret access key](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) which has admin-level permissions for your AWS account
- a fork of this repository (so that you can integrate with AWS Code Pipeline)

### 1. Create a GitHub Personal Token for CI

Go [here](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)
and follow the steps to create a personal access token for AWS Code Pipeline.
The token must have access to the `repo` scope. Store this token somewhere.

### 1. Create the Stacks

First, pick an globally unique, *alphanumeric* name for your stack:

```
export CF_DEMO_ENVIRONMENT=riskypiglet
```

The following command will create the ECR stack (which holds your application's
Docker images), the S3 stack (which holds your Cloud Formation templates), and
the master stack (which defines a VPC, ALB, ECS cluster, etc.). Note: Your
application will be built and pushed to this new ECR repository during the
stack creation process.

```sh
./.aws/cloud-formation/scripts/deploy.sh ${CF_DEMO_ENVIRONMENT} [GH username] [GH repo] [GH branch] [GH token]
```

an example invocation:

```sh
./.aws/cloud-formation/scripts/deploy.sh brazenface laser cloud-formation-ecs-docker-circle-ci master tokengoeshere
```

Once your stack reaches the `CREATE_COMPLETE` state (it could take 30+ minutes),
interrogate the stack outputs to obtain the web service URL and Code Pipeline
URL. We'll use both of these values in later steps.

```sh
export APP_URL=$(aws cloudformation \
   describe-stacks \
   --query 'Stacks[0].Outputs[?OutputKey==`WebServiceUrl`].OutputValue' \
   --stack-name ${CF_DEMO_ENVIRONMENT} | jq '.[0]' | sed -e "s;\";;g")
```

```sh
export CI_URL=$(aws cloudformation \
   describe-stacks \
   --query 'Stacks[0].Outputs[?OutputKey==`PipelineUrl`].OutputValue' \
   --stack-name ${CF_DEMO_ENVIRONMENT} | jq '.[0]' | sed -e "s;\";;g")
```

### 2. Trigger a Build

Simulate something that a developer would do, e.g. update the app:

```sh
perl -e \
    'open IN, "</usr/share/dict/words";rand($.) < 1 && ($n=$_) while <IN>;print $n' \
        | { read palabra; sed -i -e "s/\(<h1>\).*\(<\/h1>\)/<h1>${palabra}<\/h1>/g" ./websvc/app/views/posts/index.html.erb; }
```

Then, simply push your changes to the branch you configured in Step 1. Once the
build is complete, ECS will perform a blue/green deploy to your cluster. You can
follow the state of your build by navigating to the URL assigned to `${CI_URL}`:

```sh
open ${CI_URL}
```

### 3. Interact with the Application

After the stack has come online, make a request to it and verify that everything
works:

```sh
curl -v ${APP_URL}/posts
```

...or in a loop:

```sh
while true; do curl -v ${APP_URL}/posts; sleep 1; done
```

Note: It can take a few minutes for a successful build to make its way to the ECS cluster.

### 4. Deleting Everything

To delete all the stacks you've created, run the following:

```sh
./.aws/cloud-formation/delete-stacks.sh ${CF_DEMO_ENVIRONMENT}
```

### 5. Messing with the Cloud Formation Templates

If you've made changes to the Cloud Formation YAML and want to see those changes
reflected in your stack, run the following:

```sh
./.aws/cloud-formation/scripts/deploy.sh ${CF_DEMO_ENVIRONMENT} [GH username] [GH repo] [GH branch] [GH token]
```

### TODO

- [x] replace embedded app with Rails
- [ ] SSL
- [ ] Route53
- [ ] tailing (or equivalent) CloudWatch logs example
- [ ] ensure that the ALB path is configured correctly (add more paths to app)
- [x] Code Pipeline + Code Deploy
- [x] modify healthcheck to help differentiate from user requests in the logs
- [x] RDS instance + app to read database
- [x] provision an IAM user for CI and add AmazonEC2ContainerRegistryFullAccess policy
- [x] deploy script should get container and task family names from stack output
- [x] one-off task to run migrations before updating service
