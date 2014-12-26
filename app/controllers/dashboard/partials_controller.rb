class Dashboard::PartialsController < DashboardController
  layout false

  def dashboard
  end

  def account
  end

  def fundraise
  end

  def support
  end

  def places
  end

  def deliver
  end

  def invite
  end

  def payment_method
  end

  def delivery_places
  end

  def new_order
    render "dashboard/partials/orders/new"
  end

  def show_order
    render 'dashboard/partials/orders/show'
  end

  def activate
  end

  def confirm
  end

  def schools
  end

end
