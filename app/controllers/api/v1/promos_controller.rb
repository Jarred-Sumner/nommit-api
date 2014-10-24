class Api::V1::PromosController < Api::V1::ApplicationController
  before_action :apply_promo!, only: :create
  skip_before_action :require_current_user!, only: :show

  def show
    @promo = Promo.find_by!(name: promo_params)
    render partial: "api/v1/promos/promo", locals: { promo: @promo }
  end

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

    def promo_params
      params.require(:id)
    end

end
