class ModelMailer < ActionMailer::Base
  default from: "support@getnommit.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_record_notification.subject
  #
  def new_record_notification(record)
    @record = record
    mail to: "lucy@getnommit.com", subject: "Crab Rangoons on-demand"
  end
end
