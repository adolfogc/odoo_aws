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

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            dockerize \
            	-template /etc/odoo/odoo.conf.tmpl:/etc/odoo/odoo.conf \
                odoo "$@"
        fi
        ;;
    -*)
        dockerize \
            -template /etc/odoo/odoo.conf.tmpl:/etc/odoo/odoo.conf \
            odoo "$@"
        ;;
    *)
        exec "$@"
esac

exit 1
