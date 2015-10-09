class php ($module_home='/etc/puppet/modules/php') {
}

class php::restart() {
	
	exec { 'restart httpd':
		command => "/sbin/service httpd restart",
	}
}
