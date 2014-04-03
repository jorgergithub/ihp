#!/bin/bash

RUBY_VERSION="2.0.0-p353"

# Update our package manager...
sudo apt-get -y update

# Install some extras
sudo apt-get install -y ntp vim

# Remove ruby from apt since we want to compile from source
sudo apt-get remove -q -y ^.*ruby.*

# Install dependencies for Ruby
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev autoconf
sudo ntpdate pool.tnp.org
sudo service ntp restart

# Install Ruby 
if [ $(ruby -v|grep ${RUBY_VERSION//-/}|wc -l) -eq 0 ]; then
  cd /tmp
  sudo rm -rf ruby-*
  wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-${RUBY_VERSION}.tar.gz
  tar -xvzf ruby-${RUBY_VERSION}.tar.gz
  cd ruby-${RUBY_VERSION}/

  ./configure --prefix=/usr/local
  make
  sudo make install
fi

# Install Puppet gem
sudo gem update --system
sudo gem install puppet --no-ri --no-rdoc
sudo gem install bundler --no-ri --no-rdoc

# Some post install configuring for Puppet
sudo puppet resource group puppet ensure=present
sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'

# Create necessary Puppet directories
sudo mkdir -p /etc/puppet /var/lib /var/log /var/run

# Install git
sudo apt-get install -y git-core