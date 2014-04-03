class haproxy (
  $ssl                      = hiera("haproxy::ssl", true),
  $gzip                     = hiera("apache::gzip", true),
  $gzip_types               = hiera("gzip_types", undef),
  $version                  = hiera("haproxy::version", "1.4.24"),
  $major_version            = hiera("haproxy::major_version", "1.4"),
  $restart_on_change        = hiera("haproxy::restart_on_change", false),
  $reload_on_change         = hiera("haproxy::reload_on_change", true),
  $error_code_descriptions  = hiera("haproxy::error_code_descriptions", undef),
  $maxconn                  = hiera("haproxy::maxconn", 4096),
  $syslog_host              = hiera("haproxy::syslog_host", "127.0.0.1"),
  $syslog_facility          = hiera("haproxy::syslog_facility", "local0"),
  $log_level                = hiera("haproxy::log_level", "info"),
  $globals                  = hiera("haproxy::globals", undef),
  $maxconn_service          = hiera("haproxy::maxconn_service", 4096),
  $client_timeout           = hiera("haproxy::client_timeout", "4s"),
  $connect_timeout          = hiera("haproxy::connect_timeout", "15s"),
  $server_timeout           = hiera("haproxy::server_timeout", "15s"),
  $check_timeout            = hiera("haproxy::check_timeout", "10s"),
  $http_request_timeout     = hiera("haproxy::http_request_timeout", undef),
  $stats_auth               = hiera("haproxy::stats_auth", undef),
  $defaults                 = hiera("haproxy::defaults", undef),
  $backends                 = hiera("haproxy::backends"),
  $frontends                = hiera("haproxy::frontends"),
  $logrotate_file           = hiera("haproxy::logrotate_file", "haproxy.conf"),
  $logrotate_options        = hiera("haproxy::logrotate_options", undef),
  $postrotate               = hiera("haproxy::postrotate", undef),
  $prerotate                = hiera("haproxy::prerotate", undef),
  $domain                   = hiera("domain"),
  $domain_aliases           = hiera("domain_aliases", undef),
  $deploy_to                = hiera("deploy_to", undef),
  $app_name                 = hiera("app_name", undef),
  $certificate_file         = hiera("certificate_file", "/etc/ssl/certs/ssl-cert-snakeoil.pem"),
  $certificate_key_file     = hiera("certificate_key_file", "/etc/ssl/private/ssl-cert-snakeoil.key"),
  $certificate_chain_file   = hiera("certificate_chain_file", undef),
  ){
    
  include apache_server
    
  if $restart_on_change == 'true' {
    $haproxy_notifies        = Service['haproxy']
    $haproxy_service_restart = 'service haproxy restart'
  }
  elsif $reload_on_change == 'true' {
    $haproxy_notifies        = Service['haproxy']
    $haproxy_service_restart = 'service haproxy reload'
  }
  else {
    $haproxy_notifies        = []
    $haproxy_service_restart = 'service haproxy restart'
  }
  
  package { 'socat':
    ensure  => installed,
  }
    
  package { 'wget':
    ensure  => installed,
  }
  
  package { 'libpcre3-dev':
    ensure  => installed,
  }
  
  exec { 'download haproxy':
    command => "/usr/bin/wget http://haproxy.1wt.eu/download/${major_version}/src/haproxy-${version}.tar.gz",
    require => [ Package['wget'] ],
    cwd     => '/usr/local/src',
    creates => "/usr/local/src/haproxy-${version}.tar.gz",
  }
  
  exec { 'untar haproxy':
    command => "/bin/tar xzvf haproxy-${version}.tar.gz",
    require => [ Exec['download haproxy'] ],
    cwd     => '/usr/local/src',
    creates => "/usr/local/src/haproxy-${version}",
  }
  
  exec { 'compile haproxy':
    command => '/usr/bin/make TARGET=linux26 USE_PCRE=1 USE_STATIC_PCRE=1 USE_LINUX_SPLICE=1 USE_REGPARM=1',
    require => [ Exec['untar haproxy'], Package['libpcre3-dev'] ],
    cwd     => "/usr/local/src/haproxy-${version}",
    creates => "/usr/local/src/haproxy-${version}/haproxy",
  }
  
  package { 'haproxy':
    ensure    => absent,
    require  => [ Exec['compile haproxy'] ],
  }
  
  exec { 'install haproxy':
    command =>'/usr/bin/sudo /usr/bin/make install',
    timeout => '0',
    require => [ Package['haproxy'] ],
    cwd     => "/usr/local/src/haproxy-${version}",
    unless  => "/usr/bin/test -f /usr/local/sbin/haproxy && /usr/local/sbin/haproxy -v | grep 'version ${version} '",
  }
  
  file { '/etc/haproxy':
    ensure  => directory,
  }
  
  # TODO: error pages
  
  file { '/etc/haproxy/haproxy.cfg':
    ensure  => present,
    notify  => $haproxy_notifies,
    content => template('haproxy/haproxy.cfg.erb'),
  }
  
  file { '/etc/haproxy/disable_server.txt':
    ensure  => present,
    content => template('haproxy/disable_servers.txt.erb'),
  }
  
  file { '/etc/haproxy/enable_server.txt':
    ensure  => present,
    content => template('haproxy/enable_servers.txt.erb'),
  }
  
  file { '/etc/default/haproxy':
    ensure  => present,
    notify  => Service['haproxy'],
    content => "ENABLED=1\n",
  }
  
  file { '/etc/init.d/haproxy':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/haproxy/init.d',
  }
  
  service { 'haproxy':
    ensure  => running,
    enable  => true,
    restart => $haproxy_service_restart,
    require => [ Package['haproxy'], Exec['install haproxy'], File['/etc/init.d/haproxy'] ],
  }
  
  service { 'rsyslog':
    ensure  => running,
  }
  
  file { '/etc/rsyslog.d/99-haproxy.conf':
    ensure  => absent,
  }
  
  file { '/etc/rsyslog.d/40-haproxy.conf':
    ensure  => present,
    notify  => Service['rsyslog'],
    source  => 'puppet:///modules/haproxy/rsyslog.conf',
  }
  
  file { '/etc/logrotate.d/haproxy.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    content => template('logrotate/logrotate.conf.erb'),
  }
  
  apache_server::a2enmod { 'headers': mod => 'headers' }
  
  file { '/etc/apache2/':
    ensure  => directory,
    mode    => '0755',
  }
  
  file { '/etc/apache2/ports.conf':
    ensure  => present,
    mode    => '0644',
    notify  => Service['apache2'],
    source  => 'puppet:///modules/haproxy/haproxy-ports.conf',
  }
  
  apache_server::a2dissite { '000-default': site => '000-default' }
  
  file { '/etc/apache2/sites-available/default':
    ensure  => present,
    mode    => '0644',
    alias   => 'default_vhost',
    notify  => Service['apache2'],
    source  => 'puppet:///modules/haproxy/haproxy-default',
  }
  
  file { '/etc/apache2/sites-available/maintenance':
    ensure  => present,
    mode    => '0644',
    alias   => 'maintenance_vhost',
    notify  => Service['apache2'],
    content => template('haproxy/maintenance.vhost.erb'),
  }
  
  apache_server::a2ensite { 'maintenance':, site => 'maintenance', require => File['maintenance_vhost'] }
  
  # if $ssl == 'true' {
    apache_server::a2enmod { 'proxy': mod => 'proxy' }
    apache_server::a2enmod { 'proxy_http': mod => 'proxy_http' }
    apache_server::a2enmod { 'proxy_connect': mod => 'proxy_connect' }
    apache_server::a2enmod { 'ssl': mod => 'ssl' }
    
    file { '/etc/apache2/ssl':
      ensure  => directory,
      mode    => '0755',
    }
    
    file { "/etc/apache2/ssl/${app_name}":
      ensure  => directory,
      mode    => '0755',
      require => [ File['/etc/apache2/ssl'] ],
    }
    
    # file { "/etc/apache2/ssl/${app_name}/${app_name}.crt":
    #   ensure  => present,
    #   mode    => '0644',
    #   alias   => 'certificate_file',
    #   notify  => Service['apache2'],
    #   source  => "puppet:///modules/haproxy/${app_name}.crt",
    # }
    # 
    # file { "/etc/apache2/ssl/${app_name}/${app_name}.key":
    #   ensure  => present,
    #   mode    => '0644',
    #   alias   => 'certificate_key_file',
    #   notify  => Service['apache2'],
    #   source  => "puppet:///modules/haproxy/${app_name}.key",
    # }
    # 
    # file { "/etc/apache2/ssl/${app_name}/${app_name}.chain.crt":
    #   ensure  => present,
    #   mode    => '0644',
    #   alias   => 'certificate_chain_file',
    #   notify  => Service['apache2'],
    #   source  => "puppet:///modules/haproxy/${app_name}.chain.crt",
    # }
    
    file { '/etc/apache2/sites-available/haproxy':
      ensure  => present,
      alias   => 'haproxy_vhost',
      notify  => Service['apache2'],
      content => template('haproxy/haproxy.vhost.erb'),
      # require => [ File['certificate_file'], File['certificate_key_file'], File['certificate_chain_file'] ],
    }
    
    apache_server::a2ensite { 'haproxy':, site => 'haproxy', require => File['haproxy_vhost'] }
  # }
}