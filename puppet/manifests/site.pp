node basenode {
  include denyhosts,
          dnsmasq,
          gemrc,
          iptables,
          logrotate,
          motd,
          users
}

node /^haproxy\d+$/ inherits basenode {
  include haproxy
}

node /^app\d+$/ inherits basenode {
  include application
}

node /^db\d+$/ inherits basenode {
  include mysql
}

node /^worker\d+$/ inherits basenode {

}

node default inherits basenode {}