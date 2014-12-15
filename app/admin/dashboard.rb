ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  action_item do
    if Order.pending.count > 0
      link_to "View #{Order.pending.count} Pending Orders", admin_orders_path(q: { state_equals: Order.states[:active] })
    end
  end

  content do
    render 'admin/charts'
  end

end
