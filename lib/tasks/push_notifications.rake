namespace :push_notifications do

  task :find_deleted => :environment do
    feedback = Grocer.feedback(certificate: PushNotifications::BaseWorker::CERTIFICATE_PATH)

    Device.registered.find_each do |d|
      Rails.logger.info "Getting status of device: #{d.id}"

      feedback.each do |feedback|
        if d.device_token == feedback.device_token
          Rails.logger.info "Unregistered Device: #{d.id}"
          d.update_attributes!(registered: false)
        end
      end

    end
  end

end
