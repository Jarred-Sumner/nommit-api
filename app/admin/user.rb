ActiveAdmin.register User do |user|
  menu priority: 1

  sidebar "User Details", only: [:show, :edit] do
    ul do
      li link_to("Orders", admin(project))
      li link_to("Couriers", admin_project_milestones_path(project))
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
