dokku apps:create plausible

# Install plugins on Dokku
dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/dokku/dokku-clickhouse.git

# Create running plugins
dokku postgres:create plausible -I 12
dokku clickhouse:create plausible -I 20.8.17.25

# Link plugins to the main app
dokku postgres:link plausible plausible
dokku clickhouse:link plausible plausible


dokku proxy:ports-add plausible http:80:8000 https:443:8000
dokku proxy:ports-remove plausible http:80:5000 https:443:5000

dokku domains:set plausible plausible.fachschaft-wiwi.ms

dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=admin@fachschaft-wiwi.ms

# enable letsencrypt
dokku letsencrypt:enable plausible

# enable auto-renewal
dokku letsencrypt:cron-job --add

dokku config:set plausible SECRET_KEY_BASE=$(openssl rand -hex 64)

# change CLICKHOUSE_DATABASE_URL into following format
# dokku config:set plausible CLICKHOUSE_DATABASE_URL='http://plausible:password@dokku-clickhouse-plausible:8123/plausible'


# Setup Email server with admin emailer credentials
# dokku config:set plausible MAILER_EMAIL=admin@example.com \
#                            SMTP_HOST_ADDR=mail.example.com \
#                            SMTP_HOST_PORT=587 \
#                            SMTP_USER_NAME=admin@example.com \
#                            SMTP_USER_PWD=example1234 \
#                            SMTP_HOST_SSL_ENABLED=true

# Setup admin account
# dokku config:set plausible ADMIN_USER_EMAIL=admin@example.com \
#                            ADMIN_USER_NAME=admin \
#                            ADMIN_USER_PWD=admin1234 \
#                            DISABLE_REGISTRATION=true

# dokku config:set plausible BASE_URL=https://plausible.fachschaft-wiwi.ms
