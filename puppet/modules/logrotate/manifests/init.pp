class logrotate {
  package { 'logrotate':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      source  => 'puppet:///modules/logrotate/logrotate.conf';
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555',
      source  => 'puppet:///modules/logrotate/logrotate.daily';
  }
}