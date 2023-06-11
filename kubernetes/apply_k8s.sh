#! /bin/bash

kubectl apply -f istio/ecommerce-gateway.yml -n ecommerce

kubectl apply -f rabbitmq/rabbitmq-definition.yml -n ecommerce

kubectl apply -f order-service/order-service.yml -n ecommerce
kubectl apply -f order-service/order-deployment.yml -n ecommerce

kubectl apply -f shipping-service/shipping-service.yml -n ecommerce
kubectl apply -f shipping-service/shipping-deployment.yml -n ecommerce