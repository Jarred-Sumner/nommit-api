json.(school, :id, :name)

json.from_hours school.from_hours.try(:iso8601)
json.to_hours school.to_hours.try(:iso8601)

json.motd school.motd.try(:message)
json.motd_expiration school.motd.try(:expiration).try(:iso8601)

json.image_url image_url school.image(:normal)