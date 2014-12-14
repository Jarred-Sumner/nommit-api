ActiveAdmin.register Food do
  menu priority: 1

  filter :title
  filter :seller
  filter :restaurant
  filter :start_date
  filter :state

  index do |f|

    column "Preview" do |food|
      image_tag food.preview.url, class: 'food-preview'
    end

    column "Title" do |food|
      link_to food.title, admin_food_path(food)
    end

    column "Customer Satisfaction" do |food|
      if food.orders.rated.count > 0
        number_to_percentage food.customer_satisfaction, precision: 2
      else
        "No Ratings"
      end
    end

    column "Revenue" do |food|
      number_to_currency food.revenue
    end

    column "Credit Use" do |food|
      if food.orders.count > 0
        number_to_percentage food.percent_credit, precision: 2
      else
        "No Orders"
      end
    end

    column :seller
    column :restaurant
    column :start_date
    column :state

    column "Notified" do |food|
      check_box_tag "notified", food.last_notified.present?, food.last_notified.present?, readonly: true
    end



  end

  form do |f|
    f.inputs do

      f.input :title
      f.input :description
      f.input :start_date, as: :date
      f.input :expiration_date, as: :date
      f.input :preview, as: :file, hint: f.template.image_tag(f.object.preview.url)

      f.inputs "Restaurant", :for => [:restaurant, f.object.restaurant || Restaurant.new] do |cf|
        cf.input :name
        cf.input :logo, as: :file, hint: f.template.image_tag(cf.object.logo.url)
      end

      f.inputs "Seller", :for => [:seller, f.object.seller || Seller.new] do |cf|
        cf.input :name
        cf.input :logo, as: :file, hint: f.template.image_tag(cf.object.logo.url)
      end

      f.has_many :prices, allow_destroy: true, heading: 'Prices' do |cf|
        cf.input :quantity
        cf.input :price_in_cents
      end

    end
  end

  show do |food|

    attributes_table do

      row :id
      row :title

      row "Preview" do
        image_tag food.preview.url, class: "food-preview"
      end

      row :description
      row :state
      row :start_date
      row :end_date

      row :seller
      row :restaraunt

      row "Notified" do
        check_box_tag "Notified", food.last_notified.present?, food.last_notified.present?
      end

      row "Price" do
        number_to_currency food.price.price_in_cents.to_f / 100.0
      end

      row "Revenue" do
        content_tag(:strong, number_to_currency(food.revenue))
      end

      row "Real Revenue" do
        number_to_currency food.revenue - food.credit
      end

      row "Orders" do
        number_with_delimiter food.orders.placed.count
      end

      row "Credit Usage" do
        number_to_percentage food.percent_credit
      end

      row "Retained Users" do
        ids = food.orders.joins(:user).pluck(:id)
        user_ids = Order
          .group(:user_id)
          .having("COUNT(*) > 1")
          .where(user_id: ids)
          .select(:user_id)
          .count

        retained_order_count = food.orders.where(user_id: user_ids).uniq("orders.user_id").count.to_f

        retained = retained_order_count / food.orders.select(:user_id).uniq.count
        number_to_percentage retained * 100.0, precision: 2
      end

      row "Late Rate" do
        rate = food.orders.late.count.to_f / food.orders.placed.count.to_f
        content_tag :strong, number_to_percentage(rate * 100.0, { precision: 2 }), class: "late"
      end

      row "Customer Satisfaction" do
        satisfied = food.customer_satisfaction
        content_tag :strong, number_to_percentage(satisfied, { precision: 2}) + " of #{food.orders.rated.count} rated"
      end

      row "Average Delivery Time" do
        minutes = food.orders.placed.average("extract(epoch from delivered_at - created_at)").to_f / 60.0
        "#{minutes.round(2)} minutes"
      end


    end

    render 'admin/foods/low_rated_orders', food: food
    render 'admin/foods/pending_orders', food: food
    render 'admin/foods/shifts', food: food
  end

end
