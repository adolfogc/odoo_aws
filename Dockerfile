FROM amazonlinux:latest

MAINTAINER Adolfo E. García <adolfo.garcia.cr@gmail.com>

ENV LANG=en_US \
    LANGUAGE=en_US:en \
    LC_COLLATE=C \
    LC_CTYPE=en_US.UTF-8 \
    ODOO_VERSION=11.0 \
    ODOO_RELEASE=20180111 \
    ODOO_RC=/etc/odoo/odoo.conf

COPY ./odoo.conf /etc/odoo/
COPY ./entrypoint.sh /etc/odoo/

RUN set -x \
    && yum-config-manager --enable epel \
    && yum -y --setopt=tsflags=nodocs update \
    && yum -y --setopt=tsflags=nodocs install \
            python35 \
            python35-setuptools \
    && easy_install-3.5 pip \
    && curl -o /etc/yum.repos.d/yarn.repo https://dl.yarnpkg.com/rpm/yarn.repo \
    && curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - \
    && yum -y --setopt=tsflags=nodocs install \
            fontconfig \
            xz \
            zlib \
            libpng \
            libX11 \
            libXext \
            libXrender \
            xorg-x11-fonts-Type1 \
            xorg-x11-fonts-75dpi \
            nodejs \
            yarn \
            python35-devel \
            openldap-devel \
            gcc \
            gcc-c++ \
            unzip \
    && yarn global add less --prefix /usr/local \
    && curl -o tini -SL https://github.com/krallin/tini/releases/download/v0.16.1/tini-static-amd64 \
    && echo '5e01734c8b2e6429a1ebcc67e2d86d3bb0c4574dd7819a0aff2dca784580e040 tini' | sha256sum -c - \
    && chmod u+x tini \
    && mv tini /usr/bin \
    && curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && echo '049b2cdec9a8254f0ef8ac273afaf54f7e25459a273e27189591edc7d7cf29db wkhtmltox.tar.xz' | sha256sum -c - \
    && tar xvf wkhtmltox.tar.xz \
    && cp wkhtmltox/lib/* /usr/local/lib/ \
    && cp wkhtmltox/bin/* /usr/local/bin/ \
    && rm -rf wkhtmltox \
    && rm wkhtmltox.tar.xz \
    && curl -o odoo.tar.gz -SL https://nightly.odoo.com/11.0/nightly/src/odoo_${ODOO_VERSION}.${ODOO_RELEASE}.tar.gz \
    && echo 'ab93cad3b5367c351a8dd564caec2478983fc59e9603713895c07028b929b7b4 odoo.tar.gz' | sha256sum -c - \
    && pip install num2words boto3 \
    && pip install odoo.tar.gz \
    && rm odoo.tar.gz \
    && chmod u+x /etc/odoo/entrypoint.sh \
    && mkdir -p /mnt/extra-addons \
    && mkdir -p /opt/extra-addons \
    && mkdir -p /opt/custom-addons \
    && yum -y remove python35-devel openldap-devel gcc gcc-c++ \
    && yum clean all \
    && curl -o odoo-s3.zip -SL https://github.com/marclijour/odoo-s3/archive/master.zip \
    && echo 'bbce4b31cd8d91d9ddef1b070640953d40c3828f6abc3096c9a781a89564018c odoo-s3.zip' | sha256sum -c - \
    && unzip odoo-s3.zip \
    && mv odoo-s3-master /opt/extra-addons/odoo-s3 \
    && rm odoo-s3.zip \
    && useradd -r odoo \
    && chown -R odoo:odoo /etc/odoo \
    && chown -R odoo:odoo /opt \
    && chown -R odoo:odoo /mnt/extra-addons

USER odoo

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

EXPOSE 8069 8071

ENTRYPOINT ["tini", "--", "/etc/odoo/entrypoint.sh"]
CMD ["odoo"]
