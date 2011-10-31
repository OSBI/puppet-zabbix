class zabbix::agent {
  $zabbix_user_parameters = []
  $zabbix_config_dir = "/etc/zabbix"
  $zabbix_agentd_conf = "/etc/zabbix/zabbix_agentd.conf"
  $zabbix_register_sh = "/etc/zabbix/zabbix_register.sh"
  $zabbix_agent_conf = "/etc/zabbix/zabbix_agent.conf"
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

}
