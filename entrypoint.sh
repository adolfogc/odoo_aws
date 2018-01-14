#!/bin/bash

: ${ODOO_DB_HOST:=${POSTGRES_HOST:='db'}}
: ${ODOO_DB_PORT:=${POSTGRES_PORT:=5432}}
: ${ODOO_DB_USER:=${POSTGRES_USER:='odoo'}}
: ${ODOO_DB_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}

set -e

export ODOO_DB_HOST
export ODOO_DB_PORT
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
