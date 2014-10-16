class Dashboard::PartialsController < DashboardController
  layout false
  def foods
    @food = Food.first
  end

end
