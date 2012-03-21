# Class: puppet-zabbix
#
# This module manages puppet-zabbix
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class zabbix::server {
	include apache 
	include php 
	include php::apache 
	include mysql::server 
	
	package {
		["zabbix-server-mysql", "zabbix-frontend-php"] :
			ensure => present,
			#	require => Service["mysqld"],

	}
	file {
		"/etc/zabbix/dbconfig.php" :
			ensure => present,
			content => template("zabbix/dbconfig.php.erb") ;

		"/etc/zabbix/zabbix_server.d/" :
			ensure => directory,
			owner => "zabbix",
			group => "zabbix" ;

		"/etc/zabbix/alertscripts" :
			ensure => directory,
			owner => "zabbix",
			group => "zabbix" ;

		"/etc/zabbix/externalscripts" :
			ensure => directory,
			owner => "zabbix",
			group => "zabbix" ;

		"/etc/zabbix/zabbix_server.conf" :
			ensure => present,
			content => template("zabbix/zabbix_server_conf.erb") ;
	}
	mysql::database {
		"zabbix" :
			ensure => present,
			require => Class["mysql::server"]
	}
	mysql::rights {
		"zabbix rights" :
			ensure => present,
			database => "zabbix",
			user => "zabbix",
			password => "u9p7ilG2E6DycOfwKm27",
			require => Class["mysql::server"],
	}
	service {
		"zabbix-server" :
			ensure => running,
	}
	exec {
		"importzabbixschema" :
			cwd => "/tmp",
			command => "mysql -uroot zabbix < /usr/share/zabbix-server/mysql.sql",
			refreshonly => true,
			require => Mysql::Database["zabbix"],
	}
	exec {
		"importzabbixdata" :
			cwd => "/tmp",
			command => "mysql -uroot zabbix < /usr/share/zabbix-server/data.sql",
			refreshonly => true,
			require => Exec["importzabbixschema"],
	}
}
