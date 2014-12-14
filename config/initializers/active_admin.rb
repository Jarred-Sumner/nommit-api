ActiveAdmin.setup do |config|
  config.site_title = "Nommit Api"
  config.current_user_method = :current_admin_user

  config.authentication_method = :authenticate_admin_user!


  config.batch_actions = true
end
