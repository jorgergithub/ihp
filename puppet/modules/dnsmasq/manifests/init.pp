class dnsmasq (
  $listen_address = hiera("dnsmasq::listen_address", "127.0.0.1"),
  $cache_size     = hiera("dnsmasq::cache_size", 256),
  $nameservers    = hiera("dnsmasq::nameservers", "127.0.0.1"),
  ) {

  package { 'dnsmasq':
    ensure  => installed,
  }
  
  package { 'resolvconf':
    ensure  => absent,
  }
  
  file { '/etc/dnsmasq.conf':
    ensure  => present,
    owner   => 'root',
    mode    => '0744',
    require => [ Package['dnsmasq'] ],
    notify  => Service['dnsmasq'],
    content => template('dnsmasq/dnsmasq.conf.erb'),
  }
  
  file { '/etc/resolv.conf':
    ensure  => present,
    content => inline_template('<%= [ @nameservers.to_a.map { |ns| "nameserver #{ns}" }.join("\n") , "\n" ].join %>'),
  }
  
  service { 'dnsmasq':
    ensure  => running,
    restart => '/etc/init.d/dnsmasq restart',
    require => [ Package['dnsmasq'], File['/etc/dnsmasq.conf'] ],
  }
}