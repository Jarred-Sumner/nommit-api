ActiveAdmin.register User do
  menu priority: 2

  filter :name
  filter :email
  filter :phone
  filter :state
  filter :school

  index do |f|

    column "ID" do |user|
      link_to user.id, admin_user_path(user)
    end

    column :state
    column :email
    column :phone

    column :school

    column "Satisfaction" do |user|
      if user.orders.rated.count > 0

        content_tag :strong do
          number_to_percentage user.satisfaction * 100.0, precision: 2
        end

      else
        "Unknown"
      end
    end

    column "Revenue" do |user|
      number_to_currency(user.revenue.to_f / 100.0)
    end

    column "Credit" do |user|
      number_to_currency(user.credit.to_f / 100.0)
    end


    column "Orders" do |user|
      link_to user.orders.count, admin_orders_path(q: { user_id_equals: user.id })
    end

    column "Courier?" do |user|
      user.couriers.count > 0
    end

    column "School" do |user|
      link_to user.school.name, admin_school_path(user.school) if user.school
    end

  end

  show do |user|

    attributes_table do

      row :face do
        facebook_url = "https://graph.facebook.com/#{user.facebook_uid}/picture?type=square"
        link_to facebook_url do
          image_tag facebook_url
        end
      end

      row :id
      row :name
      row :email
      row :phone

      row :school

      row :facebook do
        link_to "#{user.facebook_uid}", "https://facebook.com/#{user.facebook_uid}"
      end

      row :state
      row :created_at

      row :credit do
        number_to_currency user.credit / 100.0
      end

      row :revenue do
        number_to_currency user.revenue / 100.0
      end

      row :spent do
        number_to_currency user.spent / 100.0
      end

      row :satisfaction do
        if user.orders.rated.count > 0
          content_tag :strong do
            number_to_percentage user.satisfaction * 100.0, precision: 2
          end
        else
          "Unknown"
        end
      end

      row "Organizations" do
        content_tag :div do
          content_tag_for :span, user.couriers do |courier|
            link_to courier.seller.name, admin_seller_path(courier.seller)
          end
        end
      end

      row :stripe do
        if user.payment_method.present?
          base_url = "https://dashboard.stripe.com/customers"
          base_url = "https://dashboard.stripe.com/test/customers" unless Rails.env.production?
          link_to user.payment_method.customer, "#{base_url}/#{user.payment_method.customer}"
        else
          "Unknown"
        end
      end

      row :payment_method_state do
        user.payment_method.try(:state)
      end

      row :school do
        link_to user.school.try(:name), admin_school_path(user.school)
      end

    end

    render 'admin/users/orders', user: user
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :phone
      f.input :state, as: :select, collection: User.states.keys, include_blank: false, required: true
      f.input :facebook_uid, required: true
      f.input :admin

      f.inputs "Subscription", for: [:subscription, f.object.subscription || Subscription.new] do |cf|
        cf.input :sms
        cf.input :email
      end

      f.input :school

      f.has_many :couriers, allow_destroy: true, heading: "Organizations" do |cf|
        cf.input :seller
      end

      f.action :submit

    end
  end


end
