#!/bin/bash

: ${ODOO_DB_HOST:=${POSTGRES_HOST:=${RDS_HOSTNAME:='db'}}}
: ${ODOO_DB_PORT:=${POSTGRES_PORT:=${RDS_PORT:=5432}}}
: ${ODOO_DB_NAME:=${POSTGRES_DB_NAME:=${RDS_DB_NAME}}}
: ${ODOO_DB_USER:=${POSTGRES_USER:=${RDS_USERNAME:='odoo'}}}
: ${ODOO_DB_PASSWORD:=${POSTGRES_PASSWORD:=${RDS_PASSWORD:='odoo'}}}

set -e

export ODOO_DB_HOST
export ODOO_DB_PORT
export ODOO_DB_NAME
export ODOO_DB_USER
export ODOO_DB_PASSWORD

if [ -z ${ODOO_ADMIN_PASSWORD+x} ]; then
  export ODOO_ADMIN_PASSWORD
fi

if [ -z ${ODOO_ADDONS_PATH+x} ]; then
  export ODOO_ADDONS_PATH
fi

if [ -z ${ODOO_DATA_DIR+x} ]; then
  export ODOO_DATA_DIR
fi

if [ -z ${ODOO_AWS_EFS_HOSTNAME} ]; then
  mkdir -p /mnt/filestore${ODOO_AWS_EFS_PATH}
  mount -t nfs -o proto=tcp,port=2049 ${ODOO_AWS_EFS_HOSTNAME}:${ODOO_AWS_EFS_PATH} /mnt/filestore${ODOO_AWS_EFS_PATH}
  export ODOO_FILESTORE /mnt/filstore${ODOO_AWS_EFS_PATH}
fi

if [ -z ${S3FS_IDENTITY} ]; then
  if [ -z ${S3FS_CREDENTIAL} ]; then
    echo "${S3FS_IDENTITY}:${S3FS_CREDENTIAL}"
  fi
fi

case "$1" in
    -- | openerp-server)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec openerp-server "$@"
        else
            dockerize \
            	-template /etc/openerp/openerp.conf.tmpl:/etc/openerp/openerp.conf \
                openerp-server -c /etc/openerp/openerp.conf "$@"
        fi
        ;;
    -*)
        dockerize \
            -template /etc/openerp/openerp.conf.tmpl:/etc/openerp/openerp.conf \
            openerp-server -c /etc/openerp/openerp.conf "$@"
        ;;
    *)
        exec "$@"
esac

exit 1
