class ShiftsController < ApplicationController
  before_action :require_courier!
  before_action :require_shift!, only: :update

  def index
    @shifts = current_user.shifts.limit(10).order("created_at DESC")
  end

  def create

  end

  def update
    if Integer(shift_params[:state_id]) == Shift.states[:ended]
      shift.ended!
    end
    render action: :show
  end

  def show
  end

  private

    def shift
      @shift ||= Shift.find_by(shift_params)
    end

    def shift_params
      params.require(:id).permit(:state_id)
    end

    def require_shift!
      render_not_found unless shift.present?
    end

end
