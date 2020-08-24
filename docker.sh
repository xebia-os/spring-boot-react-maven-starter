#!/bin/bash
set -e

echo "Building ui docker image..."
cd ui/
docker build -t com.xebia.starters/spring-boot-react-starter-ui .
echo "Built ui docker image..."

echo "Building api docker image..."
cd ../api
docker build -t com.xebia.starters/spring-boot-react-starter-api .
echo "Built api docker image..."


cd ../
echo "Running docker-compose up..."
docker-compose up -d