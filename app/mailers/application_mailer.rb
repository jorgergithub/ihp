class ApplicationMailer < ActionMailer::Base
  default from: "noreply@iheartpsychics.com"

  def new_application(application)
    @application = application
    file = @application.attachment
    attachments[file.original_filename] = File.open(file.path, "rb") { |f| f.read }
    mail(to: "info@iheartpsychics.com", subject: "I Heart Psychics - New application")
  end
end
