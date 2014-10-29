class AnalyticsWorker
  include Sidekiq::Worker

  def perform(event, properties = {}, user_id = nil)
    if user = User.find_by(id: user_id)
      analytics.identify(
        user_id: user.id,
        traits: {
          name: user.name,
          email: user.email,
          created_at: user.created_at,
          phone: user.phone,
          state: user.state
        }
      )

      analytics.track(user_id: user_id, anonymous_id: SecureRandom.urlsafe_base64, event: event, properties: properties)
    end
  end

  def analytics
    @analytics ||= Segment::Analytics.new({
        write_key: ENV["SEGMENT"],
        on_error: Proc.new { |status, msg| print msg }
    })
  end

end
