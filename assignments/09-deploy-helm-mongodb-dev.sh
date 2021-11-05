#!/bin/bash

kubectl create namespace student11-bookinfo-dev
kubectl config set-context $(kubectl config current-context) --namespace=student11-bookinfo-dev

sudo python3 -m pip install --upgrade pip
sudo CRYPTOGRAPHY_DONT_BUILD_RUST=1 python3 -m pip install --upgrade docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose   -o /etc/bash_completion.d/docker-compose

docker pull ghcr.io/dungpornbt/bookinfo-ratings:dev

cd ../ratings

kubectl create secret generic bookinfo-dev-ratings-mongodb-secret \
  --from-literal=mongodb-password=CHANGEME \
  --from-literal=mongodb-root-password=CHANGEME

kubectl create configmap bookinfo-dev-ratings-mongodb-initdb \
  --from-file=../ratings/databases/ratings_data.json \
  --from-file=../ratings/databases/script.sh

helm install -f k8s/helm-values/values-bookinfo-dev-ratings-mongodb.yaml \
  bookinfo-dev-ratings-mongodb bitnami/mongodb --version 10.28.4

kubectl get deployment,pod,service
