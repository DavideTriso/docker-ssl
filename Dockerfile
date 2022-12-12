FROM    certbot/certbot:latest

ENV     DOMAINS=totalcom.it
ENV     ENV=prod

RUN     apk add --no-cache openssl \
        && mkdir -p /etc/letsencrypt/live/ssl

USER    root
WORKDIR /etc/letsencrypt/live/ssl

ENTRYPOINT  if [ ! -f privkey.pem ]; then \
                openssl req -x509 -nodes -newkey rsa:4096 -days 365 \
                    -keyout privkey.pem \
                    -out fullchain.pem \
                    -subj '/CN=localhost'; \
            fi \
            && if [ $ENV = "prod" ]; then \
                certbot certonly \
                    --webroot --webroot-path /var/www/certbot \
                    --cert-name ssl \
                    --non-interactive \
                    --agree-tos \
                    --register-unsafely-without-email \
                    --domains ${DOMAINS}; \
            fi
            # TODO
            # && while true; do \
            #     certbot renew \
            #         --cert-name ssl \
            #         --domains ${DOMAINS} \
            #     && sleep 12h; \
            # done