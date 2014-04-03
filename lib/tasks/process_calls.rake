namespace :calls do
  desc "Download call information from Twilio"
  task :process => :environment do
    Call.process_calls
  end
end
