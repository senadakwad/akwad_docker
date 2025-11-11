# ==============================
# Stage: Bench Builder / Debug
# ==============================
FROM base AS builder

LABEL maintainer="akwad"

# ----------------------------------
# Install builder & development deps
# ----------------------------------
USER root

RUN microdnf install -y dnf && \
    dnf install -y \
      git wget vim-minimal grep tar findutils \
      gcc gcc-c++ make pkg-config \
      libffi-devel zlib-devel sqlite-devel xz-devel ncurses-devel file \
      openssl-devel bzip2-devel \
      postgresql-devel \
      mariadb-connector-c mariadb-connector-c-devel \
      cronie \
      shadow-utils sudo \
    && dnf clean all

# ----------------------------------
# wkhtmltopdf (RPM or generic tar)
# ----------------------------------
ARG WKHTMLTOPDF_VERSION=0.12.6.1-2
RUN wget -O /tmp/wkhtmltox.rpm \
      https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/wkhtmltox-${WKHTMLTOPDF_VERSION}.almalinux9.x86_64.rpm && \
    rpm -ivh --nodeps /tmp/wkhtmltox.rpm && \
    rm -f /tmp/wkhtmltox.rpm

# ----------------------------------
# GNU readline
# ----------------------------------
RUN curl -sL https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz | \
    tar xz && cd readline-8.2 && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && make install && \
    cd .. && rm -rf readline-8.2

# ----------------------------------
# Developer user
# ----------------------------------
RUN echo "akwad ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/akwad
USER akwad
WORKDIR /home/akwad

# ----------------------------------
# Python setup via pyenv
# ----------------------------------
ENV PYTHON_VERSION=3.12.6
ENV PYENV_ROOT=/home/akwad/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone --depth=1 https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    $PYENV_ROOT/bin/pyenv install $PYTHON_VERSION && \
    PYENV_VERSION=$PYTHON_VERSION pip install --no-cache-dir virtualenv && \
    $PYENV_ROOT/bin/pyenv global $PYTHON_VERSION && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# ----------------------------------
# Disable pip hash verification globally
# ----------------------------------
USER root
RUN echo -e "[global]\nrequire-hashes = false" > /etc/pip.conf
USER akwad
RUN mkdir -p /home/akwad/.config/pip && \
    echo -e "[global]\nrequire-hashes = false" > /home/akwad/.config/pip/pip.conf

# ----------------------------------
# PostgreSQL driver (for runtime testing)
# ----------------------------------
RUN PYENV_VERSION=$PYTHON_VERSION pip install --no-cache-dir psycopg2-binary

# ----------------------------------
# Node.js + Yarn (for asset building)
# ----------------------------------
ENV NODE_VERSION=20.19.2
ENV NVM_DIR=/home/akwad/.nvm
ENV PATH=${NVM_DIR}/versions/node/v${NODE_VERSION}/bin/:${PATH}

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
    . ${NVM_DIR}/nvm.sh && \
    nvm install ${NODE_VERSION} && \
    nvm use ${NODE_VERSION} && \
    npm install -g yarn && \
    nvm alias default ${NODE_VERSION} && \
    rm -rf ${NVM_DIR}/.cache && \
    echo 'export NVM_DIR="/home/akwad/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# ----------------------------------
# Bench CLI
# ----------------------------------
ENV PATH=/home/akwad/.local/bin:$PATH
ARG GIT_REPO=https://github.com/frappe/bench.git
ARG GIT_BRANCH=v5.x

RUN git clone --depth=1 -b ${GIT_BRANCH} ${GIT_REPO} /home/akwad/.bench && \
    pip install --no-cache-dir --user -e /home/akwad/.bench && \
    echo "export PATH=\$HOME/.local/bin:\$PATH" >> ~/.bashrc && \
    echo "export BENCH_DEVELOPER=1" >> ~/.bashrc

# Expose typical dev ports
EXPOSE 8000-8005 9000-9005 6787

# Default dev/debug behavior
WORKDIR /home/akwad
ENV PATH="/home/akwad/.local/bin:/home/akwad/.pyenv/shims:/home/akwad/.pyenv/bin:${PATH}"
CMD ["sleep", "infinity"]
