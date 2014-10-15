class InviteWorker
  include Sidekiq::Worker
  sidekiq_options queue: :invites

  def perform(contacts = [])
    contacts.each do |contact|
    end
  end
end
