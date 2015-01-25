ActiveAdmin.register Seller do

  filter :title
  filter :school

  index do |f|

    column :name do |s|
      link_to s.name, admin_seller_path(s.id)
    end

    column :logo do |seller|
      image_tag seller.logo.url, height: 50, width: 50
    end

    column :customer_satisfaction do |s|
      number_to_percentage s.customer_satisfaction
    end

    column :revenue do |s|
      number_to_currency s.revenue
    end

  end

  show do |seller|
    
    attributes_table do
      row :id
      row :name

      row :logo do
        image_tag seller.logo.url, height: 50, width: 50
      end

      row :foods do
        link_to "Foods - #{seller.foods.count}", admin_foods_path(q: { seller_id_equals: seller.id })
      end

      row :school do
        link_to seller.school.name, admin_school_path(seller.school.id)
      end

      row :revenue do
        number_to_currency seller.revenue
      end

      row :payout do
        number_to_currency seller.payout_calculator.payout
      end

      row :late_rate do
        number_to_percentage seller.late_rate * 100.0, precision: 2
      end

      row :customer_satisfaction do
        number_to_percentage seller.customer_satisfaction
      end

      row :orders do
        number_with_delimiter seller.orders.count
      end

      row :cancellation_rate do
        number_to_percentage (seller.orders.cancelled.count.to_f / seller.orders.count.to_f) * 100.0
      end

    end

  end

end
