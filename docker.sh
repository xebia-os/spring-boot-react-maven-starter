#!/bin/bash
set -e

echo "Building api and ui docker image..."
docker build -t com.mannanlive.starter/spring-boot-react-starter .
echo "Built api and ui docker image..."

echo "Running docker-compose up..."
docker-compose up -d