json.(subscription, :sms, :email)
json.push_notifications subscription.user.devices.registered.count > 0
