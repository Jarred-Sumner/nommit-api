class ShiftsController < ApplicationController
  before_action :require_courier!
  before_action :require_shift!, :require_authorized_courier!, only: :update

  def index
    @shifts = current_user.shifts.limit(10).order("created_at DESC")
  end

  def create

  end

  def update
    # Changing the shift state?
    if shift_params.has_key?(:state_id)
      if Integer(shift_params[:state_id]) == Shift.states[:ended]
        shift.ended!
        shift.delivery_places.update_all(state: "ended")
      elsif Integer(shift_params[:state_id]) == Shift.states[:halted]
        shift.halted!
        shift.delivery_places.update_all(state: "ended")
      end
    # Changing the current delivery place?
    elsif delivery_place.present?

      # You might be wondering why we do this here, rather than in DeliveryPlacesController
      # Well, this change affects all the DeliveryPlaces in the Shift model.
      # We need the latest version of all DeliveryPlaces for this Shift immediately afterwards, and it would be improper to return that in DeliveryPlaces#update
      # So, it goes here.
      if Integer(dp_params[:delivery_place_state_id]) == DeliveryPlace.states[:arrived]
        ActiveRecord::Base.transaction do
          delivery_place.shift.delivery_places.update_all(state: "ready")
          delivery_place.arrived!
          delivery_place.shift.update_delivery_times!
        end
      end
    end
    render action: :show
  end

  def show
  end

  private

    def shift
      @shift ||= Shift.find_by(id: shift_params[:id], courier: courier)
    end

    def delivery_place
      @delivery_place ||= shift.delivery_places.find_by(id: dp_params[:delivery_place_id])
    end

    def shift_params
      params.permit(:id, :state_id)
    end

    # Get your mind out of the gutter.
    def dp_params
      params.permit(:delivery_place_id, :delivery_place_state_id)
    end

    def require_shift!
      render_not_found if shift.nil?
    end

    def require_authorized_courier!
      render_forbidden unless shift.courier_id == courier.id
    end

end
