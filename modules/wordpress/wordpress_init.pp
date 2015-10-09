class wordpress ($module_home='/etc/puppet/modules/wordpress') {
}

class wordpress::wget() {
    
    exec { 'wget wordpress':
    	cwd     => "/var/www/html",
        command => "/usr/bin/wget http://wordpress.org/latest.tar.gz",
    }
}

class wordpress::untar() {
	require wordpress::wget
	
	exec { 'untar wordpress':
		cwd     => "/var/www/html",
		command => "/bin/tar -xzvf latest.tar.gz",
	}
}

class wordpress::move() {
	require wordpress::untar
	
	exec { 'move wordpress':
		cwd     => "/var/www/html",
		command => "/bin/mv wordpress blog",
	}
}