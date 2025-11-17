FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4

LABEL maintainer="akwad"

# Core runtime deps shared by all services
USER root
RUN microdnf install -y \
      tzdata \
      postgresql-libs \
      openssl-libs ca-certificates nss libffi && \
    microdnf clean all

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create non-root user matching your bench volume
RUN groupadd -g 1000 akwad && \
    useradd -m -u 1000 -g 1000 -G wheel akwad

USER akwad
