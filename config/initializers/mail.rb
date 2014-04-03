unless Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    :user_name => 'iheartpsychics',
    :password => 'iheart123',
    :domain => 'iheartpsychics.co',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }

  ActionMailer::Base.default_url_options[:host] = ENV['MAILER_HOST'] || 'iheartpsychics.co'
end
