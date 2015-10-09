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