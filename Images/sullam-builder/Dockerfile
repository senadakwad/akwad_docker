ARG BUILDER_IMAGE=276418048997.dkr.ecr.me-south-1.amazonaws.com/frappe/builder:latest

ARG BENCH_USER=akwad
ARG BENCH_HOME=/home/${BENCH_USER}
ARG BENCHES_DIR=${BENCH_HOME}/benches

ARG BENCH_NAME=sullam-bench
ARG PYTHON_VERSION=3.12.6


FROM ${BUILDER_IMAGE} AS builder

ARG BENCH_USER
ARG BENCH_HOME
ARG BENCHES_DIR
ARG BENCH_NAME

USER ${BENCH_USER}
WORKDIR ${BENCHES_DIR}


RUN bench init ${BENCH_NAME} --no-procfile --no-backups --skip-redis-config-generation
RUN cd ${BENCHES_DIR}/${BENCH_NAME} && \
    rm -rf env && \
    python3 -m venv env --copies && \
    env/bin/pip install --upgrade pip wheel setuptools && \
    bench setup requirements && \
    bench build --production

COPY common_site_config.json /home/akwad/benches/${BENCH_NAME}/sites/common_sites_config.json


WORKDIR ${BENCHES_DIR}/${BENCH_NAME}
