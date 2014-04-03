class iptables (
  $rules  = hiera("iptables::rules", undef),
  ){
  
  package { 'iptables':
    ensure  => installed,
  }
  
  file { '/etc/iptables.rules':
    ensure  => present,
    mode    => '0744',
    owner   => 'root',
    require => [ Package['iptables'] ],
    content => template('iptables/iptables.rules.erb'),
  }
  
  file { '/etc/network/if-pre-up.d/iptables-restore':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    require => [ Package['iptables'], File['/etc/iptables.rules'] ],
    source  => 'puppet:///modules/iptables/iptables-rules',
  }
  
  exec { '/sbin/iptables-restore < /etc/iptables.rules':
    refreshonly => true,
    subscribe   => [ File['/etc/iptables.rules'] ],
  }
}