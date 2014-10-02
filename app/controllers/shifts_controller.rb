class ShiftsController < ApplicationController
  before_action :require_courier!
  before_action :require_shift!, :require_authorized_courier!, only: [:update, :show]
  before_action :require_at_least_one_place!, only: :create

  def index
    @shifts = current_user.shifts.limit(10).order("created_at DESC")
  end

  def create
    ActiveRecord::Base.transaction do
      @shift = courier.shifts.create!
      @shift.deliver_to!(places: Array(place_ids))
    end
    render action: :show
  end

  def update
    # Changing the shift state?
    if shift_params.has_key?(:state_id)
      if Integer(shift_params[:state_id]) == Shift.states[:ended]
        if shift.orders.pending.count > 0
          shift.halt_shift!
          return render_error(status: :unprocessable_entity, text: "Please fulfill the remaining #{shift.orders.active.count} order(s) before ending your shift.")
        else
          shift.end_shift!
        end
      elsif Integer(shift_params[:state_id]) == Shift.states[:halt]
        shift.halt_shift!
      end
    elsif shift_params.has_key?(:place_ids)
      shift.deliver_to!(places: shift_params[:place_ids])
    # Changing the current delivery place?
    elsif delivery_place.present?

      # You might be wondering why we do this here, rather than in DeliveryPlacesController
      # Well, this change affects all the DeliveryPlaces in the Shift model.
      # We need the latest version of all DeliveryPlaces for this Shift immediately afterwards, and it would be improper to return that in DeliveryPlaces#update
      # So, it goes here.
      if Integer(dp_params[:delivery_place_state_id]) == DeliveryPlace.states[:arrived]
        delivery_place.arrive!
      end
    end
    render action: :show
  rescue ArgumentError => e
    render_error(status: :bad_request, text: e.message)
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
      params.permit(:id, :state_id, { place_ids: [] })
    end

    def place_ids
      params.require(:place_ids)
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

    def require_at_least_one_place!
      render_error(status: :bad_request, text: "Please select at least one place to deliver to") if Place.where(id: Array(params[:place_ids])).count.zero?
    end

end