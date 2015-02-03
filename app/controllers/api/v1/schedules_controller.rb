class Api::V1::SchedulesController < Api::V1::ApplicationController
  before_action :require_courier!, :require_food!

  def create
    @food = food.version!(create_params)
    render partial: "api/v1/foods/food", food: @food
  end

  private

    def food
      @sellable_food ||= SellableFood.find(Integer(params[:food_id]))
    end

    def require_food!
      render_forbidden unless food.present?
    end

    def create_params
      return @create_params if @create_params

      params.require(:start_date)
      params.require(:end_date)
      params.require(:goal)

      @create_params = params.permit(:start_date, :end_date, :goal)

      @create_params[:start_date] = DateTime.parse(@create_params[:start_date])
      @create_params[:end_date] = DateTime.parse(@create_params[:end_date])
      @create_params[:goal] = Integer(@create_params[:goal])

      @create_params
    end

end