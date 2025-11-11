# ===============================
# Frappe Web Runtime Image
# ===============================
FROM base AS frappe-web

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

# Switch back to your runtime user
USER akwad

