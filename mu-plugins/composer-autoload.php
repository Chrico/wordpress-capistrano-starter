<?php
/**
 * Plugin Name: Composer autoload
 * Plugin URI:  https://github.com/Chrico/wordpress-capistrano-starter
 * Description: This Plugin detects the autoload.php in WP_CONTENT_DIR for other plugins which are loaded via composer-autoload.
 * Author:      ChriCo
 * Author URI:  https://www.chrico.info
 * Version:     1.0
 * License:     GPLv3
 */

if ( ! defined( 'WP_CONTENT_DIR' ) ) {
	exit;
}

$autoload_file = WP_CONTENT_DIR . '/vendor/autoload.php';
if ( file_exists( $autoload_file ) ) {
	include_once( $autoload_file );
} else {
	add_action(
		'admin_notices', 
		function () {
	
			$msg = sprintf(
				'Please exec <code>composer install</code> in <code>%s</code>.',
				WP_CONTENT_DIR
			);
	
			echo '<div class="error"><p>' . $msg . '</p></div>';
		}
	);

	return;
}