class zabbix::server {

include mysql::server

package { ["zabbix-server-mysql", "zabbix-frontend-php"]:
	ensure => present,
	require => Service["mysqld"],
	}
    
    file {
        #"/etc/zabbix/zabbix_server.conf":
        #    ensure  => present,
        #    content => template("zabbix/zabbix_server.conf.erb");
        "/etc/zabbix/zabbix_server.d/":
            ensure => directory,
            owner  => "zabbix",
            group  => "zabbix";
        "/etc/zabbix/alertscripts":
            ensure => directory,
            owner  => "zabbix",
            group  => "zabbix";
        "/etc/zabbix/externalscripts":
            ensure => directory,
            owner  => "zabbix",
            group  => "zabbix";
    }


}