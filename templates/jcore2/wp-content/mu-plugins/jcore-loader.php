<?php
/*
Plugin Name: JCOre Loader
Description: Custom loader for JCOre mu-plugins.
*/

/*
 *  This loader loads certain plugins from the mu-plugins folder.
 *  It should check that the plugins don't exist in the normal plugins folder, for backwards compatibility, and to allow
 *  quick fixes by installing newer versions. And also ignore any missing plugins from mu-plugins.
 */

// Load Timber.
if ( ! is_dir( WP_CONTENT_DIR.'/plugins/timber-library' ) && file_exists(WPMU_PLUGIN_DIR.'/timber-library/vendor/autoload.php') ) {
	require WPMU_PLUGIN_DIR.'/timber-library/vendor/autoload.php';
	new \Timber\Timber;
}

// Load ACF.
if ( ! is_dir( WP_CONTENT_DIR.'/plugins/advanced-custom-fields-pro' ) && file_exists(WPMU_PLUGIN_DIR.'/advanced-custom-fields-pro/acf.php') ) {
	require_once WPMU_PLUGIN_DIR.'/advanced-custom-fields-pro/acf.php';
}
