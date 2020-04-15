#!/bin/sh

DNS_PLUGIN=/certbot-alydns-plugin/au.sh
AUTH_HOOK="$DNS_PLUGIN python aly add"
CLEANUP_HOOK="$DNS_PLUGIN python aly clean"

case $1 in
certonly)
    shift
    certbot \
        certonly \
        --manual \
        --preferred-challenges dns \
        --manual-auth-hook "$AUTH_HOOK" \
        --manual-cleanup-hook "$CLEANUP_HOOK" \
        $@
;;
*)
    certbot $@
;;
esac