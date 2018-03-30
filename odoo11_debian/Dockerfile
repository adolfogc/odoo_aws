# Based on https://github.com/odoo/docker/blob/master/11.0/Dockerfile

FROM debian:stretch

ENV LANG=en_US \
    LANGUAGE=en_US:en \
    LC_COLLATE=C \
    LC_CTYPE=en_US.UTF-8 \
    ODOO_VERSION=11.0 \
    ODOO_RELEASE=20180329 \
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
    && curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && echo '049b2cdec9a8254f0ef8ac273afaf54f7e25459a273e27189591edc7d7cf29db wkhtmltox.tar.xz' | sha256sum -c - \
    && tar xvf wkhtmltox.tar.xz \
    && cp wkhtmltox/lib/* /usr/local/lib/ \
    && cp wkhtmltox/bin/* /usr/local/bin/ \
    && cp -r wkhtmltox/share/man/man1 /usr/local/share/man/ \
    && curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && echo 'b82cd767a827e61af62b4bb4ba72908d26a7323cda5648cdeab45301ef9cc62c odoo.deb' | sha256sum -c - \
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
