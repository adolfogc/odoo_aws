# Based on https://github.com/odoo/docker/blob/master/11.0/Dockerfile

FROM debian:stretch

ENV LANG=en_US \
    LANGUAGE=en_US:en \
    LC_COLLATE=C \
    LC_CTYPE=en_US.UTF-8 \
    ODOO_VERSION=11.0 \
    ODOO_RELEASE=20180923 \
    ODOO_RC=/etc/odoo/odoo.conf

RUN set -x \
    && apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        node-less \
        python3-pip \
        python3-setuptools \
        python3-renderpm \
        xz-utils \
        fonts-noto \
        gcc \
        libssl-dev \
    && curl -o wkhtmltox.deb -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
    && echo '1140b0ab02aa6e17346af2f14ed0de807376de475ba90e1db3975f112fbd20bb *wkhtmltox.deb' | sha256sum -c - \
    && dpkg --force-depends -i wkhtmltox.deb \
    && curl -o odoo.deb -SL https://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && echo '6f63848a79de6175143e7b931e716ac4fab0a171e7bfec7fd17b8a5fc0767516 odoo.deb' | sha256sum -c - \
    && dpkg --force-depends -i odoo.deb \
    && apt-get update \
    && apt-get -y install -f --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* odoo.deb \
    && pip3 install num2words xlwt phonenumbers boto3

COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/

RUN chown odoo /etc/odoo/odoo.conf \
    && chmod u+x /entrypoint.sh \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons \
    && mkdir -p /var/lib/odoo \
    && chown -R odoo /var/lib/odoo

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
EXPOSE 8069 8072
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
