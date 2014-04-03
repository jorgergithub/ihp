namespace :clients do
  desc "Assign unsubscribe keys to users"
  task :assign_unsubscribe_keys => :environment do
    Client.where('unsubscribe_key IS NULL').find_each do |c|
      c.save
    end
  end
end
