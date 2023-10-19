#!/bin/bash

# Usually no need to edit these.
WEBROOT="/var/www/html" # The webroot in the container.
CHARSET="utf8mb4" # DB charset
LOCALE="utf8mb4_unicode_ci" # DB locale used for collation and such.
PREFIX="wp_" # WordPress DB prefix
DB="wordpress" # DB name
USER=$DB # DB username
PASSWORD=$USER # DB password, this is local so weak password is ok.
EMAIL="developer@jco.fi" # Default email for WP initial config. Not very important.
# Backwards compatibility defaults for old projects.
LOCAL_PLUGINS=(
    'loco-translate'
    'pattern-manager'
)

if [[ -f "config.sh" ]]; then
    . config.sh
elif [[ -f "/project/config.sh" ]]; then
    . /project/config.sh
else
    echo "config.sh not found"
    exit 1
fi

# Some backwards compatibility stuff.

if [ -z $REMOTEHOST ]; then
    REMOTEHOST=$REMOTE
fi
if [ -z $REMOTEHOST ]; then
    REMOTEHOST="$WPENAME@$WPENAME.ssh.wpengine.net"
fi
if [ -z $REMOTEPATH ]; then
    REMOTEPATH="/sites/$WPENAME"
fi
if [ -z $PLUGIN_EXCLUDE ]; then
    PLUGIN_EXCLUDE=$EXCLUDE
fi
if [ -z $DEBUG ]; then
  DEBUG=true
fi

# Logic stuff.

# Get the first domain as the primary name
domainFirst=(${DOMAINS[0]//;/ })
PRIMARY=${domainFirst[0]}

if [ ${#domainFirst[1]} -eq 0 ]; then
    DOMAINNAME="$PRIMARY.localhost"
else
    DOMAINNAME="${domainFirst[1]}.localhost"
fi
