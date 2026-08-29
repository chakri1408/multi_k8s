#!/bin/bash
set -e   # stop immediately if any build/push/kubectl command fails

docker build -t chakri1408/multi-client:latest -t chakri1408/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t chakri1408/multi-server:latest -t chakri1408/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t chakri1408/multi-worker:latest -t chakri1408/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push chakri1408/multi-client:latest
docker push chakri1408/multi-server:latest
docker push chakri1408/multi-worker:latest

docker push chakri1408/multi-client:$SHA
docker push chakri1408/multi-server:$SHA
docker push chakri1408/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=chakri1408/multi-server:$SHA
kubectl set image deployments/client-deployment client=chakri1408/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=chakri1408/multi-worker:$SHA