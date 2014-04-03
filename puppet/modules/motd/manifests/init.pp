class motd {
  file { "/etc/motd":
    ensure => file,
    owner  => 'root',
    mode   => '0777',
    source => "puppet:///modules/motd/motd",
  }
}