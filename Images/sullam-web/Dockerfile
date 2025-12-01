# ===============================
# Frappe Web Runtime Image
# ===============================
FROM 276418048997.dkr.ecr.me-south-1.amazonaws.com/sullam/runtime:latest

LABEL maintainer="akwad"

USER root

# Install wkhtmltopdf + minimal runtime libraries it depends on
ARG WKHTMLTOPDF_VERSION=0.12.6.1-2
RUN microdnf install -y \
      fontconfig libX11 libXext libXrender libjpeg-turbo libpng freetype \
      && microdnf clean all && \
    curl -L -o /tmp/wkhtmltox.rpm \
      https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox-${WKHTMLTOPDF_VERSION}.almalinux9.x86_64.rpm && \
    rpm -ivh --nodeps /tmp/wkhtmltox.rpm && \
    rm -f /tmp/wkhtmltox.rpm

#Nginx
RUN chmod o+x /home/akwad/ && \
    chmod o+r /home/akwad/

RUN microdnf install -y nginx && microdnf clean all

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN curl -sSL -o /usr/local/bin/gosu \
      https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64 \
 && chmod +x /usr/local/bin/gosu

RUN cd /home/akwad/benches/sullam-bench/ && mkdir -p logs && chown akwad:akwad logs


# Switch back to your runtime user


VOLUME ["/home/akwad/benches/sullam-bench/sites/dockerdemo.akwad.qa"]

EXPOSE 80 8000

CMD ["bash", "-lc", "\
    mkdir -p logs && \
    nginx -g 'daemon off;' & \
    gosu akwad bash -lc 'cd sites && exec ../env/bin/gunicorn \
        --bind 0.0.0.0:8000 \
        --workers 2 \
        --threads 4 \
        --timeout 120 \
        --graceful-timeout 30 \
        --max-requests 5000 \
        --max-requests-jitter 500 \
        frappe.app:application --preload' \
"]



