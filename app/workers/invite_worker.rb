class InviteWorker
  include Sidekiq::Worker
  sidekiq_options queue: :invites

  def perform(contacts = [])
    
  end
end
