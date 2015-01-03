class ApplicationMailer < ActionMailer::Base
  default "Message-ID" => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@getnommit.com"
  default from: '"Nommit" <support@getnommit.com>'
  layout "email"
  include ActionView::Helpers::NumberHelper
end