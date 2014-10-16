class TwilioAutomatedMessageWorker
  include Sidekiq::Worker

  def perform(to)
    Texter.run("To get in touch with Nommit support, text us at #{COMPANY_PHONE}", to)
  end
end
