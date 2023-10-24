#!/usr/bin/env bash
source /project/.config/config-wrapper.sh

# Create Private / Public key if it doesn't exist
if [ ! -f ~/.ssh/id_ed25519 ]; then
	ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -P ""
fi

if [[ ! -f "$WEBROOT/index.php" || ! -f "$WEBROOT/wp-includes/version.php" ]]; then
  wp core download --path=$WEBROOT --skip-content
fi
if [[ ! -f "$WEBROOT/wp-config.php" ]]; then
  echo "Waiting to configure in case DB is not created."
  sleep 8
  echo "Creating wp-config.php"
  echo "wp config create --path=$WEBROOT --dbhost=$WORDPRESS_DB_HOST --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbcharset=$CHARSET --dbprefix=$PREFIX"
  wp config create --path=$WEBROOT --dbhost=$WORDPRESS_DB_HOST --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbcharset=$CHARSET --dbprefix=$PREFIX
  wp config set --path=$WEBROOT memcached_servers "array( array( 'memcached', 11211 ) )" --raw --type=variable
  echo "Creating DB."
  wp db create --path=$WEBROOT
  echo "wp db create --path=$WEBROOT"
  if ! wp core is-installed --path=$WEBROOT; then
    echo "WP not installed, installing."
    echo "wp core install --path=$WEBROOT --title=Wordpress --url=$DOMAINNAME --admin_user=$NAME --admin_email=$EMAIL --admin_password=$PASSWORD"
    wp core install --path=$WEBROOT --title=Wordpress --url=$DOMAINNAME --admin_user=$NAME --admin_email=$EMAIL --admin_password=$PASSWORD
  fi
  /project/.config/scripts/importplugins
  /project/.config/scripts/importdb
fi

# Add WP_HOME and WP_SITEURL to wp-config.php
wp config set --path=$WEBROOT --type=constant WP_HOME "https://$DOMAINNAME"
wp config set --path=$WEBROOT --type=constant WP_SITEURL "https://$DOMAINNAME"
wp config set --path=$WEBROOT --type=constant WP_DEBUG $WP_DEBUG --raw
wp config set --path=$WEBROOT --type=constant WP_DEBUG_LOG $WP_DEBUG_LOG --raw
wp config set --path=$WEBROOT --type=constant WP_DEBUG_DISPLAY $WP_DEBUG_DISPLAY --raw
wp config set --path=$WEBROOT --type=constant JCORE_IS_LOCAL true --raw

/project/.config/scripts/appendssl

# Start PHP-FPM
php-fpm
