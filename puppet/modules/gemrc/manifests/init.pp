class gemrc {
  file { "/etc/gemrc":
    ensure  => file,
    owner   => 'root',
    mode    => '0744',
    source  => "puppet:///modules/gemrc/gemrc",
  }
}