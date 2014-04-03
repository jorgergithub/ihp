class application (
  $app_name                 = hiera("app_name", undef),
  $allow_override           = hiera("application::allow_override", None),
  $gzip                     = hiera("application::gzip", true),
  $gzip_types               = hiera("gzip_types", undef),
  $passenger_version        = hiera("application::passenger_version", "4.0.29"),
  $domain                   = hiera("domain", undef),
  $domain_aliases           = hiera("domain_aliases", undef),
  $ssl                      = hiera("application::ssl", undef),
  $ssl_only                 = hiera("application::ssl_only", true),
  $deploy_to                = hiera("deploy_to", undef),
  $asset_pipeline_enabled   = hiera("application::asset_pipeline_enabled", true),
  $rails_auto_detect        = hiera("application:rails_auto_detect", on),
  $rails_env                = hiera("rails_env", staging),
  $rails_spawn_method       = hiera("application::rails_spawn_method", smart),
  $min_instances            = hiera("application::min_instances", 3),
  $pre_start_url            = hiera("application::pre_start_url", undef),
  $maintenance_status_code  = hiera("application::maintenance_status_code", 503),
  $page_cache_directory     = hiera("page_cache_directory", undef),
  $certificate_file         = hiera("certificate_file", "/etc/ssl/certs/ssl-cert-snakeoil.pem"),
  $certificate_key_file     = hiera("certificate_key_file", "/etc/ssl/private/ssl-cert-snakeoil.key"),
  $certificate_chain_file   = hiera("certificate_chain_file", undef),
  $ssl_protocol             = hiera("application::ssl_protocol", undef),
  $logrotate_file           = hiera("haproxy::logrotate_file", "applogs.conf"),
  $logrotate_options        = hiera("haproxy::logrotate_options", undef),
  $postrotate               = hiera("haproxy::postrotate", undef),
  $prerotate                = hiera("haproxy::prerotate", undef),
  $user                     = hiera("user", root),
  $log_level                = hiera("application::log_level", 0),
  $user_switching           = hiera("application::user_switching", "On"),
  $max_pool_size            = hiera("application::max_pool_size", 6),
  $max_instances_per_app    = hiera("application::max_instances_per_app", 6),
  $pool_idle_time           = hiera("application::pool_idle_time", 600),
  $max_requests             = hiera("application::max_requests", 0),
  $stat_throttle_rate       = hiera("application::stat_throttle_rate", 0),
  $buffer_response          = hiera("application::buffer_response", "On"),
  $friendly_error_pages     = hiera("application::friendly_error_pages", "Off"),
  ){
    
  include apache_server
  
  package { 'libcurl4-openssl-dev':
    ensure  => installed,
  }
  
  package { 'apache2-threaded-dev':
    ensure  => installed,
  }
  
  package { 'libapr1-dev':
    ensure  => installed,
  }
  
  package { 'libaprutil1-dev':
    ensure  => installed,
  }
  
  package { 'bundler':
    ensure    => installed,
    provider  => gem,
  }
  
  package { 'passenger':
    ensure    => $passenger_version,
    provider  => gem,
    require   => [ Package['libcurl4-openssl-dev'] ],
  }
  
  package { 'mysql2':
    ensure    => installed,
    provider  => gem,
  }
  
  exec { 'build passenger':
    command => '/usr/bin/sudo /usr/local/bin/ruby -S rake clean apache2',
    cwd     => "/usr/local/lib/ruby/gems/2.0.0/gems/passenger-${passenger_version}",
    unless  => '/usr/bin/test -f /etc/apache2/mods-available/passenger.conf',
    timeout => 108000,
    require => [ Package['libcurl4-openssl-dev'], Package['apache2-threaded-dev'], Package['libapr1-dev'], Package['libaprutil1-dev'], Package['passenger'] ],
  }
  
  $load_template = "LoadModule passenger_module /usr/local/lib/ruby/gems/2.0.0/gems/passenger-${passenger_version}/buildout/apache2/mod_passenger.so"
  
  file { '/etc/apache2/mods-available/passenger.load':
    ensure  => present,
    content => $load_template,
    require => [ Exec['build passenger'] ],
    notify  => Service['apache2'],
    alias   => 'passenger_load',
  }
  
  file { '/etc/apache2/mods-available/passenger.conf':
    ensure  => present,
    content => template('application/passenger.conf.erb'),
    require => [ Exec['build passenger'] ],
    notify  => Service['apache2'],
    alias   => 'passenger_conf',
  }
  
  apache_server::a2enmod { 'headers': mod => 'headers' }
  apache_server::a2enmod { 'passenger': mod => 'passenger', require => Exec['build passenger'] }
  
  file { "/etc/apache2/sites-available/${app_name}":
    ensure  => present,
    alias   => 'passenger_vhost',
    notify  => Service['apache2'],
    content => template('application/passenger.vhost.erb'),
    require  => [Exec['a2enmod passenger'] ],
  }
  
  file { "/etc/logrotate.d/${app_name}logs.conf":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    content => template('logrotate/logrotate.conf.erb'),
  }
  

}