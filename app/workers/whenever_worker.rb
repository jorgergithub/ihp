class WheneverWorker
  include Sidekiq::Worker

  def perform
    system "bundle exec whenever --update-crontab"
  end
end
