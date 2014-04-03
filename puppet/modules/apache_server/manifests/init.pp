class apache_server (
  $ssl                      = hiera("apache::ssl", undef),
  $gzip                     = hiera("apache::gzip", true),
  $gzip_types               = hiera("gzip_types", undef),
  $timeout                  = hiera("apache::timeout", 300),
  $trace_enable             = hiera("apache::trace_enable", "On"),
  $keep_alive               = hiera("apache::keep_alive", "Off"),
  $max_keep_alive_requests  = hiera("apache::max_keep_alive_requests", 100),
  $keep_alive_timeout       = hiera("apache::keep_alive_timeout", 15),
  $start_servers            = hiera("apache::start_servers",  2),
  $max_clients              = hiera("apache::max_clients", 150),
  $server_limit             = hiera("apache::server_limit", 16),
  $min_spare_threads        = hiera("apache::min_spare_threads", 25),
  $max_spare_threads        = hiera("apache::max_spare_threads", 75),
  $threads_per_child        = hiera("apache::threads_per_child", 25),
  $max_requests_per_child   = hiera("apache::max_requests_per_child", 0),
  $envvars                  = hiera("apache::envvars", undef),
  $logrotate_file           = hiera("haproxy::logrotate_file", "apache2.conf"),
  $logrotate_options        = hiera("haproxy::logrotate_options", undef),
  $postrotate               = hiera("haproxy::postrotate", undef),
  $prerotate                = hiera("haproxy::prerotate", undef),
  ){
  
  define a2enmod($mod) {
    exec { "a2enmod ${mod}":
      command => "/usr/sbin/a2enmod ${mod}",
      unless  => "/bin/ls /etc/apache2/mods-enabled/${mod}.load",
      require => [ Package['apache2-mpm-worker'] ],
      notify  => Service['apache2'],
    }
  }
  
  define a2dismod($mod) {
    exec { "a2dismod ${mod}":
      command => "/usr/sbin/a2dismod ${mod}",
      onlyif  => "/bin/ls /etc/apache2/mods-enabled/${mod}.load",
      require => [ Package['apache2-mpm-worker'] ],
      notify  => Service['apache2'],
    }
  }
  
  define a2ensite($site) {
    exec { "a2ensite ${site}":
      command => "/usr/sbin/a2ensite ${site}",
      unless  => "/bin/ls /etc/apache2/sites-enabled/${site}",
      require => [ Package['apache2-mpm-worker'] ],
      notify  => Service['apache2'],
    }
  }
  
  define a2dissite($site) {
    exec { "a2dissite ${site}":
      command => "/usr/sbin/a2dissite ${site}",
      onlyif  => "/bin/ls /etc/apache2/sites-enabled/${site}",
      require => [ Package['apache2-mpm-worker'] ],
      notify  => Service['apache2'],
    }
  }
  
  package { 'apache2-mpm-worker':
    ensure  => installed,
  }
  
  service { 'apache2':
    ensure  => running,
    restart => 'service apache2 restart',
    require => [ Package['apache2-mpm-worker'] ],
  }
  
  a2enmod { 'rewrite': mod => 'rewrite' }
  a2enmod { 'status': mod => 'status' }
  a2enmod { 'expires': mod => 'expires' }
  
  if $ssl == 'true' {
    a2enmod { 'headers': mod => 'headers' }
    a2enmod { 'ssl': mod => 'ssl' }
  }
  
  if $gzip == 'true' {
    a2enmod { 'deflate': mod => 'deflate' }
  }
  
  file { '/etc/apache2/apache2.conf':
    ensure  => present,
    mode    => '0644',
    require => [ Package['apache2-mpm-worker'] ],
    notify  => Service['apache2'],
    content => template('apache_server/apache2.conf.erb'),
  }
  
  # file { '/etc/apache2/envvars':
  #   ensure  => present,
  #   mode    => '0644',
  #   require => [ Package['apache2-mpm-worker'] ],
  #   notify  => Service['apache2'],
  #   content => template('apache_server/apache.envvars.erb'),
  # }
  
  file { '/etc/apache2/mods-available/status.conf':
    ensure  => present,
    mode    => '0644',
    require => [ Exec['a2enmod status'] ],
    notify  => Service['apache2'],
    source  => 'puppet:///modules/apache_server/status',
  }
  
  file { '/etc/logrotate.d/apache2.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    content => template('logrotate/logrotate.conf.erb'),
  }
}