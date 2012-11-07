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
class zabbix::agent {
	$zabbix_user_parameters = []
	$zabbix_config_dir = "/etc/zabbix"
	$zabbix_agentd_conf = "/etc/zabbix/zabbix_agentd.conf"
	$zabbix_register_sh = "/etc/zabbix/zabbix_register.sh"
	$zabbix_agent_conf = "/etc/zabbix/zabbix_agent.conf"
	package {
		["zabbix-agent", "libio-all-lwp-perl", "LWP.pm"] :
			ensure => installed ;
	}
	service {
		"zabbix-agent" :
			enable => true,
			ensure => running,
			hasstatus => true,
			require => Package["zabbix-agent"]
	}
	file {
		$zabbix_config_dir :
			ensure => directory,
			owner => root,
			group => root,
			mode => 0755,
			require => Package["zabbix-agent"] ;

		$zabbix_agent_conf :
			owner => root,
			group => root,
			mode => 0644,
			content => template("zabbix/zabbix_agent_conf.erb"),
			require => Package["zabbix-agent"] ;

		$zabbix_agentd_conf :
			owner => root,
			group => root,
			mode => 0644,
			content => template("zabbix/zabbix_agentd_conf.erb"),
			require => Package["zabbix-agent"] ;
	}
	
	file{"/usr/local/mysql_performance_monitor_agent-0.9.tar.gz":
	  ensure => present,
	  source => "puppet:///modules/zabbix/mysql_performance_monitor_agent-0.9.tar.gz"
	} ->
	 exec { "extract":
    command => "tar xvfz mysql_performance_monitor_agent-0.9.tar.gz",
    creates => "/usr/local/mysql_performance_monitor_agent-0.9",
    user => "root",
    path    => "/usr/bin/:/bin/:/home/ingres/ingres/bin:/home/ingres/ingres/utility",    
  } ->
  file { "/usr/local/mysql_performance_monitor":
    ensure => link,
    source => "/usr/local/mysql_performance_monitor_agent-0.9"
    
  }-> 
  file {"/usr/local/mysql_performance_monitor/etc/FromDualMySQLagent.conf":
    ensure => present,
    content => template("FromDualMySQLagent.conf.template.erb"),
    
  }
}