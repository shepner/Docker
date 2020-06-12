#!/bin/sh
# https://bitnami.com/stack/apache-airflow
# https://github.com/bitnami/bitnami-docker-airflow


curl -LO https://raw.githubusercontent.com/bitnami/bitnami-docker-airflow/master/docker-compose.yml
sudo docker-compose up
