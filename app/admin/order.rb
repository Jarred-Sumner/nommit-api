ActiveAdmin.register Order do
  menu priority: 1

  filter :state
  filter :user_id
  filter :food
  filter :created_at
  filter :delivered_at

  index do

    column "ID" do |order|
      link_to order.id, admin_order_path(order)
    end

    column "Food" do |order|
      link_to order.food.title, admin_food_path(order.food)
    end

    column "Price" do |order|
      number_to_currency order.price.price_in_cents.to_f / 100.0
    end

    column "Place" do |order|
      link_to order.place.name, admin_place_path(order.place)
    end

    column "Courier" do |order|
      link_to order.courier.user.name, admin_user_path(order.courier.user)
    end

    column :state

    column "User" do |order|
      link_to order.user.name, admin_user_path(order.user)
    end

    column "School" do |user|
      link_to user.school.name, admin_school_path(user.school)
    end

    column :created_at
    column :rating
  end

  show do |order|

    attributes_table do

      row :id
      row :state
      row :rating

      row :user do
        link_to order.user.name, admin_user_path(order.user)
      end

      row :food do
        link_to order.food.title, admin_food_path(order.food)
      end

      row :courier do
        link_to order.courier.user.name, admin_user_path(order.user)
      end

      row :place do
        link_to order.place.name, admin_place_path(order.place)
      end

      row :school do
        link_to order.school.name, admin_school_path(order.school)
      end

      row :delivery_estimate do
        distance_of_time_in_words(order.delivered_at, order.created_at)
      end

      row :price do
        number_to_currency order.price.price_in_cents.to_f / 100.0
      end

      row :credit do
        number_to_currency order.discount_in_cents.to_f / 100.0
      end

      row :stripe do
        if charge_id = order.charge.charge
          url = "https://dashboard.stripe.com/payments/"
          url = "https://dashboard.stripe.com/test/payments/" unless Rails.env.production?
          link_to charge_id, url
        end
      end

      row :quantity

    end

  end

end
