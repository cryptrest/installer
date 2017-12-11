#!/bin/sh

/home/cryptrest/letsencrypt/certbot/certbot-auto certonly --standalone --email crypt.rest@gmail.com --renew-by-default --rsa-key-size 4096 -d crypt.rest -d www.crypt.rest --pre-hook "service nginx stop" --post-hook "service nginx start"
