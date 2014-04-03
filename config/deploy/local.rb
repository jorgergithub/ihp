set :stage, :local

# the primary server in each group is considered to be the first
role :local   , %w{ haproxy1.webbynode.net }

set :ssh_options, {
  user: fetch(:user),
  forward_agent: true,
  auth_methods: %w(publickey password)
}

fetch(:default_env).merge!(rails_env: :staging)
