class Api::V1::PromosController < Api::V1::ApplicationController
  before_action :require_promo!

  def create
    apply_promo_to_user!(name: promo_code)
    render current_user
  end

  private

    def promo_code
      params.require(:code)
    end

end
