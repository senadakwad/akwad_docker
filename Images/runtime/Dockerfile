# syntax=docker/dockerfile:1.4

########################################
# Build-time configuration (ARGS)
########################################
ARG BUILDER_IMAGE=276418048997.dkr.ecr.me-south-1.amazonaws.com/frappe/builder:latest
ARG RUNTIME_BASE=276418048997.dkr.ecr.me-south-1.amazonaws.com/frappe/base

ARG BENCH_USER=akwad
ARG BENCH_HOME=/home/${BENCH_USER}
ARG BENCHES_DIR=${BENCH_HOME}/benches

ARG BENCH_NAME=sullam-bench
ARG PYTHON_VERSION=3.12.6

########################################
# Runtime: lightweight final image
########################################
FROM ${RUNTIME_BASE}

########################################
# Bring in all ARGS
########################################
ARG BENCH_USER
ARG BENCH_HOME
ARG BENCHES_DIR
ARG BENCH_NAME
ARG PYTHON_VERSION

LABEL maintainer="runtime-${BENCH_USER}"

########################################
# Ensure correct permissions + directories
########################################
USER root

RUN mkdir -p ${BENCHES_DIR} && \
    chown ${BENCH_USER}:${BENCH_USER} ${BENCH_HOME}


USER ${BENCH_USER}
WORKDIR ${BENCHES_DIR}/${BENCH_NAME}

########################################
# Copy Python venv + Frappe apps
########################################
COPY --from=sullam/builder ${BENCHES_DIR}/${BENCH_NAME}/env ./env
COPY --from=sullam/builder ${BENCHES_DIR}/${BENCH_NAME}/apps ./apps
# Copy Python runtime
COPY --from=sullam/builder /home/akwad/.pyenv/versions/3.12.6/bin \
    /home/akwad/python/bin

COPY --from=sullam/builder /home/akwad/.pyenv/versions/3.12.6/lib/libpython3.12.so.1.0 \
    /home/akwad/python/lib/libpython3.12.so.1.0

COPY --from=sullam/builder /home/akwad/.pyenv/versions/3.12.6/lib/python3.12 \
    /home/akwad/python/lib/python3.12

########################################
# Copy only build assets
########################################
# This folder is static and identical across containers for a release
COPY --from=sullam/builder ${BENCHES_DIR}/${BENCH_NAME}/sites/assets ./sites/assets

ENV PYTHONHOME=/home/akwad/python
ENV PATH=/home/akwad/python/bin:$PATH
ENV LD_LIBRARY_PATH=/home/akwad/python/lib:$LD_LIBRARY_PATH
