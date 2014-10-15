require 'invite_worker'

class Api::V1::InvitesController < Api::V1::ApplicationController

  def create
    Array(contact_params).each_slice(50) { |contacts| InviteWorker.perform_async(current_user.id, contacts) }
    render status: 200, json: {}
  end

  private

    def contact_params
      params.require(:contacts)
    end

end
