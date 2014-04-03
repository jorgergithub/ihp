class denyhosts (
  $admin_email = hiera("denyhosts::admin_email", "root@localhost"),
  $allow       = hiera("denyhosts::hosts_allow", "127.0.0.1"),
  ) {

  package { 'denyhosts':
    ensure => installed,
  }
  
  file { '/etc/denyhosts.conf':
    ensure  => present,
    notify  => Service['denyhosts'],
    require => [ Package['denyhosts'] ],
    content => template('denyhosts/denyhosts.conf.erb'),
  }
  
  service { 'denyhosts':
    ensure  => running,
    require => [ Package['denyhosts'], File['/etc/denyhosts.conf'] ],
  }
  
  file { '/etc/hosts.allow':
    ensure  => present,
    content => inline_template('<%= [ @allow.to_a.join("\n") , "\n" ].join %>'),
    notify  => Service['denyhosts'],
  }
}