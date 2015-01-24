ActiveAdmin.register Seller do

  filter :title
  filter :school

  index do |f|

    column :name

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

end
