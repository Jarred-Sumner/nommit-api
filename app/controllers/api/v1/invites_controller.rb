require 'invite_worker'

class Api::V1::InvitesController < Api::V1::ApplicationController

  def create
    Array(contact_params).each_slice(100) { |contacts| InviteWorker.perform_async(contacts) }
    render status: 200, json: {}
  end

  private

    def contact_params
      params.require(:contacts)
    end

end
