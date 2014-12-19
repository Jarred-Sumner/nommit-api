ActiveAdmin.register School do

  index do

    column "ID" do |school|
      link_to school.id, admin_school_path(school)
    end

    column :name

    column :revenue do |school|
      number_to_currency school.revenue
    end

    column :buyers do |school|
      number_with_delimiter school.users.buyers.count
    end

  end


end
