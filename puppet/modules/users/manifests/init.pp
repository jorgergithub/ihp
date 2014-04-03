class users (
  $active     = hiera("users::active"),
  $disabled   = hiera("users::disabled"),
  $deploy_to  = hiera("deploy_to", undef),
  $user       = hiera("user", undef),
  ) {
    
  setup_users { $active: }
  remove_users { $disabled: }
  
  define setup_users() {
    user { $name:
      ensure => present,
      home   => "/home/${name}",
      shell  => '/bin/bash',
    }
  
    file { "/home/${name}":
      ensure  => directory,
      owner   => $name,
      require => [ User["${name}"] ],
    }
  
    file { "/home/${name}/.ssh":
      ensure  => directory,
      mode    => '0700',
      owner   => $name,
      require => [ File["/home/${name}"] ],
    }
  
    file { "/home/${name}/.ssh/authorized_keys":
      ensure  => file,
      mode    => '0600',
      owner   => $name,
      require => [ File["/home/${name}/.ssh"] ],
      source  => "puppet:///modules/users/${name}_authorized_keys",
    }
  
    file { "/home/${name}/.gemrc":
      ensure  => file,
      mode    => '0644',
      owner   => $name,
      require => [ File["/home/${name}"] ],
      source  => 'puppet:///modules/users/gemrc',
    }
  }
  
  define remove_users() {
    user { $name:
      ensure  => absent,
      shell   => '/bin/nologin',
    }
  }
  
  file { $deploy_to:
    ensure  => directory,
    owner   => $user,
    mode    => '0775',
  }
}