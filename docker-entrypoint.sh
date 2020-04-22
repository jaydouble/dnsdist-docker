#!/usr/bin/env bash
set -e

mkdir -p /etc/dnsdist/conf.d
mkdir -p /etc/dnsdist/cert
chown -R _dnsdist:_dnsdist /etc/dnsdist/

if [ ! -f /etc/dnsdist/dnsdist.conf ]
then
    cp /etc/dnsdist_org/dnsdist.conf /etc/dnsdist/dnsdist.conf
fi

exec /usr/bin/dnsdist --verbose --supervised "$@"
