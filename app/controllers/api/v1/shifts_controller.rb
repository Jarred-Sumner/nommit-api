class Api::V1::ShiftsController < Api::V1::ApplicationController
  before_action :require_courier!, only: [:create]
  before_action :require_shift!, :require_authorized_courier!, only: [:update, :show]
  before_action :require_no_ongoing_shifts!, :require_at_least_one_place!, only: :create

  def index
    @shifts = current_user.shifts.limit(10).order("created_at DESC")
  end

  def create
    ActiveRecord::Base.transaction do
      @shift = courier.shifts.create!
      @shift.deliver!(places: place_ids, foods: food_ids)
      track_started_shift(@shift)
      render action: :show
    end
  rescue ArgumentError => e
    render_error(status: :bad_request, text: e.message)
  end

  def update
    # Changing the shift state?
    if shift_params.has_key?(:state_id)
      if Integer(shift_params[:state_id]) == Shift.states[:ended]
        if shift.orders.pending.count.zero?
          shift.ended!
          track_ended_shift(@shift)
        else
          shift.halt!
          track_halted_shift(@shift)
          return render_error(status: :unprocessable_entity, text: "Please fulfill the remaining #{shift.orders.active.count} order(s) before ending your shift.")
        end
      end
    elsif shift_params.has_key?(:place_ids)
      shift.deliver!(places: shift_params[:place_ids])
      track_shift_changed_delivery_places(shift)
    # Changing the current delivery place?
    elsif delivery_place.present?

      # You might be wondering why we do this here, rather than in DeliveryPlacesController
      # Well, this change affects all the DeliveryPlaces in the Shift model.
      # We need the latest version of all DeliveryPlaces for this Shift immediately afterwards, and it would be improper to return that in DeliveryPlaces#update
      # So, it goes here.

      if Integer(dp_params[:delivery_place_state_id]) == DeliveryPlace.states[:arrived]
        if delivery_place.ready?
          delivery_place.arrive!
        else
          delivery_place.notify_pending_orders!
        end
        track_delivery_place_arrived(delivery_place)
      elsif Integer(dp_params[:delivery_place_state_id]) == DeliveryPlace.states[:ready]
        delivery_place.left!
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
      @shift ||= current_user.shifts.find_by(id: shift_params[:id])
    end

    def delivery_place
      @delivery_place ||= shift.delivery_places.find_by(id: Integer(dp_params[:delivery_place_id]))
    end

    def shift_params
      params.permit(:id, :state_id, { place_ids: [] })
    end

    def place_ids
      Array(params.require(:place_ids))
    end

    def food_ids
      Array(params[:food_ids]).collect { |id| Integer(id) }.uniq.compact
    end

    # Get your mind out of the gutter.
    def dp_params
      params.permit(:delivery_place_id, :delivery_place_state_id)
    end

    def require_shift!
      render_not_found if shift.nil?
    end

    def require_no_ongoing_shifts!
      ongoing_shifts = courier.shifts.where(state: [Shift.states[:active], Shift.states[:halt]]).count
      render_bad_request("Please finish your pending shift before starting a new one") if ongoing_shifts > 0
    end

    def require_authorized_courier!
      render_forbidden unless current_user.couriers.pluck(:id).include? shift.courier_id
    end

    def require_at_least_one_place!
      render_error(status: :bad_request, text: "Please select at least one place to deliver to") if Place.where(id: Array(params[:place_ids])).count.zero?
    end

end
