class mysql (
  $innodb_log_buffer_size     = hiera("mysql::innodb_log_buffer_size", "64M"),
  $innodb_log_file_size       = hiera("mysql::innodb_log_file_size", "80M"),
  $innodb_log_files_in_group  = hiera("mysql::innodb_log_files_in_group", 3),
  $app_name                   = hiera("app_name", undef),
  $allowed_hosts              = hiera("mysql::allowed_hosts", undef),
  $db_username                = hiera("mysql::db_username", undef),
  $db_password                = hiera("mysql::db_password", undef),
  ){
  
  package { 'libmysqlclient-dev':
    ensure => installed,
  }
  
  package { 'mysql-server':
    ensure  => installed,
  }
  
  service { 'mysql':
    ensure  => running,
    require => [ Package['mysql-server'] ],
  }
  
  file { '/etc/mysql':
    ensure  => directory,
  }
  
  file { '/etc/mysql/conf.d':
    ensure  => directory,
  }
  
  exec { 'create database':
   command  => "/bin/su -c \'/usr/bin/mysql -u root -e \"create database ${app_name};\"\'",
   unless   => "/bin/su -c \'/usr/bin/mysql -u root -e \"show create database ${app_name};\"\'",
   require  => Service['mysql'],
  }
  
  $grant = "GRANT ALL PRIVILEGES ON ${app_name} TO ${db_username}@${name} IDENTIFIED BY \"${db_password}\"; FLUSH PRIVILEGES;"
  
  define db_user($user, $database, $db_pass) {
    exec { "${name}_mysql_user":
      command => "/usr/bin/sudo /bin/su -c \'/usr/bin/mysql -u root -e \"GRANT ALL PRIVILEGES ON ${database}.* TO ${user}@${name} IDENTIFIED BY \\\"${db_pass}\\\"; FLUSH PRIVILEGES;\"\'",
      unless  => "/usr/bin/mysql -u root -e 'select User from user where Host = \"${name}\"' mysql | grep ${user}",
      require => Exec['create database'],
    }
  }
  
  db_user { $allowed_hosts: user => $db_username, database => $app_name, db_pass => $db_password }
  
  package { 'mytop':
    ensure  => installed,
  }
  
  package { 'wget':
    ensure  => installed,
  }
  
  exec { 'wget mysqltuner.pl':
    command => '/usr/bin/wget -O mysqltuner.pl mysqltuner.pl --no-check-certificate && chmod a+x /usr/sbin/mysqltuner.pl',
    cwd     => '/usr/sbin/',
    creates => '/usr/sbin/mysqltuner.pl',
    require => Package['wget'],
  }
}