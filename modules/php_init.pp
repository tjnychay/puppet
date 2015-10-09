class php ($module_home='/etc/puppet/modules/php') {
}

class php::restart() {
	require php::install
	
	exec { 'restart httpd':
		command => "/sbin/service httpd restart",
	}
}
