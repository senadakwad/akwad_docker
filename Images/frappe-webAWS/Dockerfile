# ================================
# Stage 1 — Bench builder
# ================================
FROM 276418048997.dkr.ecr.me-south-1.amazonaws.com/frappe/builder:latest AS builder

# Create the bench with env/apps/sites using pyenv python
RUN cd /home/akwad/benches && \
    bench init sullam-bench --no-procfile --no-backups --skip-redis-config-generation && \
    cd /home/akwad/benches/sullam-bench && \
    bench build --production


# ================================
# Stage 2 — Runtime (web)
# ================================
FROM 276418048997.dkr.ecr.me-south-1.amazonaws.com/frappe/runtime:latest

LABEL maintainer="akwad"

USER root

# wkhtmltopdf (as you already had)
ARG WKHTMLTOPDF_VERSION=0.12.6.1-2
RUN microdnf install -y \
      fontconfig libX11 libXext libXrender libjpeg-turbo libpng freetype \
    && microdnf clean all && \
    curl -L -o /tmp/wkhtmltox.rpm \
      https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox-${WKHTMLTOPDF_VERSION}.almalinux9.x86_64.rpm \
    && rpm -ivh --nodeps /tmp/wkhtmltox.rpm \
    && rm -f /tmp/wkhtmltox.rpm

# make sure home exists & perms are right (usually already in runtime)
RUN mkdir -p /home/akwad && chown -R akwad:akwad /home/akwad

USER akwad
WORKDIR /home/akwad

# 💡 KEY FIX: copy the whole pyenv tree from builder
COPY --from=builder /home/akwad/.pyenv /home/akwad/.pyenv

# copy the full bench (env/apps/sites structure)
COPY --from=builder /home/akwad/benches/sullam-bench /home/akwad/benches/sullam-bench

# set pyenv in PATH so env/bin/python symlink target actually exists
ENV PYENV_ROOT=/home/akwad/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

WORKDIR /home/akwad/benches/sullam-bench

# sites will be EFS-mounted
VOLUME ["/home/akwad/benches/sullam-bench/sites"]

EXPOSE 8000

CMD ["bash", "-lc", \
  "cd /home/akwad/benches/sullam-bench/sites && \
   exec ../env/bin/gunicorn \
     --bind 0.0.0.0:8000 \
     --workers 2 \
     --threads 4 \
     --timeout 120 \
     --graceful-timeout 30 \
     --max-requests 5000 \
     --max-requests-jitter 500 \
     frappe.app:application --preload"]
