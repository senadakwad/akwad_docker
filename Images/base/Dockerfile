FROM registry.access.redhat.com/ubi9/ubi-minimal:latest AS base

LABEL maintainer="akwad"

# Core runtime deps shared by all services
RUN microdnf install -y \
      glibc-langpack-en tzdata \
      python3 python3-pip \
      postgresql \
      dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts \
  && microdnf clean all

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create non-root user matching your bench volume
RUN groupadd -g 1000 akwad && \
    useradd -m -u 1000 -g 1000 -G wheel akwad

# Default working directory where bench volume mounts
VOLUME ["/home/akwad"]
