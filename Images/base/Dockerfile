FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

LABEL maintainer="akwad"

# Core runtime deps shared by all services
USER root
RUN microdnf install -y \
      # Locale and timezone
      glibc-langpack-en tzdata \
      # Python runtime
      python3 python3-pip \
      # Database client runtime (libpq)
      postgresql-libs \
      # Core crypto and TLS
      openssl-libs ca-certificates nss libffi \
      # Compression and archiving (std modules: zlib, bz2, lzma)
      zlib bzip2-libs xz-libs \
      # Fonts (for wkhtmltopdf / report rendering if reused)
      dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts \
      # C++ runtime libs required by compiled Python wheels
      libstdc++ libgcc \
  && microdnf clean all



ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create non-root user matching your bench volume
RUN groupadd -g 1000 akwad && \
    useradd -m -u 1000 -g 1000 -G wheel akwad

USER akwad
