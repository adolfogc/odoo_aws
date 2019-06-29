# Based on https://github.com/odoo/docker/blob/master/12.0/Dockerfile
FROM python:3.7-slim-stretch

ENV LANG=C.UTF-8 \
    ODOO_VERSION=12.0 \
    ODOO_RELEASE=20190629 \
    ODOO_CHECKSUM=be4e797c7fbdcc64637113a4ac17f52afd4016988bbefa9ad4304d1bf351d096 \
    ODOO_RC=/etc/odoo/odoo.conf \
    TINI_VERSION=v0.18.0

RUN set -x; \
    echo "Setup apt sources" \
      && rm -rf /var/lib/apt/lists/* \
      && echo "deb http://deb.debian.org/debian stretch main" > /etc/apt/sources.list \
      && echo "deb http://deb.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list \
      && echo "deb http://deb.debian.org/debian stretch-updates main" >> /etc/apt/sources.list \
      && echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list \
      && apt-get update \
    && echo "Install dependencies with apt-get" \
      && apt-get install -y --fix-broken --fix-missing --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl1.0-dev \
        python3-pip \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-vobject \
        python3-watchdog \
        xz-utils \
        gcc \
        fontconfig \
        libx11-6 \
        libxcb1 \
        libxext6 \
        libxrender1 \
        xfonts-75dpi \
        xfonts-base \
    && echo "Installing dependencies with pip" \
      && pip3 install --upgrade pip \
      && pip3 --no-cache-dir install wheel num2words xlwt phonenumbers boto3 \
    && echo "Installing Wkhtmltox" \
      && curl -o wkhtmltox.deb -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
      && echo '1140b0ab02aa6e17346af2f14ed0de807376de475ba90e1db3975f112fbd20bb *wkhtmltox.deb' | sha256sum -c - \
      && dpkg --force-depends -i wkhtmltox.deb \
      && apt --fix-broken install \
    && echo "Installing latest postgresql-client" \
      && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' > etc/apt/sources.list.d/pgdg.list \
      && export GNUPGHOME="$(mktemp -d)" \
      && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
      && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
      && gpg --armor --export "${repokey}" | apt-key add - \
      && gpgconf --kill all \
      && rm -rf "$GNUPGHOME" \
      && apt-get update  \
      && apt-get install -y postgresql-client-11 \
    && echo "Installing rtlcss" \
      && echo "deb http://deb.nodesource.com/node_8.x stretch main" > /etc/apt/sources.list.d/nodesource.list \
      && export GNUPGHOME="$(mktemp -d)" \
      && repokey='9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280' \
      && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
      && gpg --armor --export "${repokey}" | apt-key add - \
      && gpgconf --kill all \
      && rm -rf "$GNUPGHOME" \
      && apt-get update \
      && apt-get install -y nodejs \
      && npm install -g rtlcss \
      && rm -rf /var/lib/apt/lists/* \
    && echo "Installing Odoo" \
      && curl -o odoo.deb -SL https://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
      && echo "${ODOO_CHECKSUM} odoo.deb" | sha256sum -c - \
      && dpkg --force-depends -i odoo.deb \
    && echo "Cleaning up" \
      && apt-get update \
      && apt-get -y install -f --no-install-recommends \
      && rm -rf /var/lib/apt/lists/* odoo.deb

COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 /tini

RUN chown odoo /etc/odoo/odoo.conf \
    && chmod +x /entrypoint.sh \
    && chown odoo /entrypoint.sh \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons \
    && mkdir -p /var/lib/odoo \
    && chown -R odoo /var/lib/odoo \
    && chmod +x /tini

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
EXPOSE 8069 8072
USER odoo

ENTRYPOINT ["/tini", "--"]
CMD ["/entrypoint.sh", "odoo"]
