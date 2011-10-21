class zabbix::agent {
	$zabbix_user_parameters = []
 	$zabbix_config_dir = "/etc/zabbix"
    $zabbix_agentd_conf = "$zabbix_config_dir/zabbix_agentd.conf"
    $zabbix_register_sh = "$zabbix_config_dir/zabbix_register.sh"

    package {
        "zabbix-agent":
            ensure => installed;
    }

    service {
        "zabbix-agent":
            enable => true,
            ensure => running,
            hasstatus => true,
            require => Package["zabbix-agent"]
    }

    file {
        $zabbix_config_dir:
            ensure => directory,
            owner => root,
            group => root,
            mode => 0755,
            require => Package["zabbix-agent"];    

        $zabbix_register_sh:
            owner => root,
            group => root,
            mode => 0700,
            content => template("zabbix/zabbix_register.sh.erb"),
            require => Package["zabbix-agent"];

        $zabbix_agent_conf:
            owner => root,
            group => root,
            mode => 0644,
            content => template("zabbix/zabbix_agent_conf.erb"),
            require => Package["zabbix-agent"];

        $zabbix_agentd_conf:
            owner => root,
            group => root,
            mode => 0644,
            content => template("zabbix/zabbix_agentd_conf.erb"),
            require => Package["zabbix-agent"];
    }

    exec { $zabbix_register_sh:  }
}