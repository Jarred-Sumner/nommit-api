json.(subscription, :sms, :email, :id)
json.push_notifications subscription.user.devices.registered.count > 0
