#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Instructions

# Edit if:
# NAME: The project name. Defaults to folder name.
# THEME: If theme name is different from project name.
# REMOTE: The SSH path to the remote host.
# REMOTEPATH: The remote webroot.
# DOMAINS: If the upstream site is live, or you know what the live site name will be.

#NAME="vagrant"
THEME="$NAME" # The active theme.
#BRANCH="master"
WPE="$NAME"

# Default WPE values
REMOTEHOST="$WPE@$WPE.ssh.wpengine.net"
REMOTEPATH="/sites/$WPE"
# Default WPdev values
#REMOTEHOST="webmaster@wpdev.bojaco.com"
#REMOTEPATH="/var/www/wpdev/$NAME"

# The full domain of the upstream website.
# If you want to use separate names for vagrant hosts enter the vagrant name after a ";", like this "$NAME.wpengine.com;example.com".
# Don't add the ".test" to the vagrant name, it will be added automatically.
DOMAINS=(
    "$WPE.wpengine.com;$NAME"
)

# Exclude these tables from DB export. Usually bacause of size.
DB_EXCLUDE=(
    'relevanssi'
)

# Exclude these plugins from sync, this goes both ways, so remote plugins you don't want locally,
# or local plugins you don't have remotely but want kept locally.
PLUGIN_EXCLUDE=(
    'minimal-coming-soon-maintenance-mode'
    'coming-soon'
    'loco-translate'
    'pattern-manager'
    'hyperdb'
    'hyperdb-1-1'
)
# This is the same as PLUGIN_EXCLUDE, but also tells git to include these in version tracking.
# So these should always be local.
PLUGIN_GIT=(
)
# Activate these plugins locally after sync.
LOCAL_PLUGINS=(
    'loco-translate'
    'pattern-manager'
)
# Set this to "composer" for projects where composer is used to install plugins.
PLUGIN_INSTALL="remote"
