#!/bin/bash

: ${ODOO_DB_HOST:=${POSTGRES_HOST:='db'}}
: ${ODOO_DB_PORT:=${POSTGRES_PORT:=5432}}
: ${ODOO_DB_USER:=${POSTGRES_USER:='odoo'}}
: ${ODOO_DB_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}

set -e

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            dockerize \
            	-template /etc/odoo/odoo.conf.tmpl:/etc/odoo/odoo.conf \
                -wait tcp://${ODOO_DB_HOST}:${ODOO_DB_PORT} odoo "$@"
        fi
        ;;
    -*)
        dockerize \
            -template /etc/odoo/odoo.conf.tmpl:/etc/odoo/odoo.conf \
            -wait tcp://${ODOO_DB_HOST}:${ODOO_DB_PORT} odoo "$@"
        ;;
    *)
        exec "$@"
esac

exit 1
