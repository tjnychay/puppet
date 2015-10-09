class mysql ($module_home='/etc/puppet/modules/mysql') {
}


class mysql::start() {

        exec { 'mysql start':
                command => "/sbin/service mysqld start",
        }
}

class mysql::database() {
        require mysql::start

        exec { 'create blog database':
                command => "/usr/bin/mysqladmin -uroot create blog",
        }
}

class mysql::password() {
	require mysql::database

	exec { 'set mysql root password':
    		path => "/usr/bin",
    		unless => "mysql -uroot -p test",
    		command => "mysqladmin -u root password test",
	}
}
