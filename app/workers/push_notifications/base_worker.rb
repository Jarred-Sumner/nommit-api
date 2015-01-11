class PushNotifications::BaseWorker
  include Sidekiq::Worker
  include ActionView::Helpers::NumberHelper
  attr_accessor :user

  CERTIFICATE_PATH = ENV["APN_CERTIFICATE_PATH"] unless defined?(CERTIFICATE_PATH)

  def pusher
    @pusher ||= Grocer.pusher(certificate: CERTIFICATE_PATH)
  end

  def notification_params(device)
    {
      device_token: device.device_token,
      badge: 0
    }
  end

end
