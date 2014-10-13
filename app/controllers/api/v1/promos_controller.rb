class Api::V1::PromosController < Api::V1::ApplicationController
  before_action :apply_promo!, only: :create

  def create
    render current_user
  end

  private

    def apply_promo!
      apply_promo_to_user!(name: promo_code)
    end

    def promo_code
      params.require(:code)
    end

end
