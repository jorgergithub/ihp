set :stage, :production

# the primary server in each group is considered to be the first
role :web   , %w{ haproxy1.ihp.webbynode.net }
role :app   , %w{ app1.ihp.webbynode.net app2.ihp.webbynode.net }
role :db    , %w{ db1.ihp.webbynode.net db2.ihp.webbynode.net }
role :worker, %w{ worker1.ihp.webbynode.net }

set :ssh_options, {
  user: fetch(:user),
  forward_agent: true,
  auth_methods: %w(publickey password)
}


fetch(:default_env).merge!(rails_env: :production)
