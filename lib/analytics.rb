class Analytics

  def self.track(event: nil, properties: {}, user_id: nil)
    AnalyticsWorker.perform_async(event, properties, user_id)
  end

end
