json.(school, :id, :name)

json.from_hours school.from_hours.try(:iso8601)
json.to_hours school.to_hours.try(:iso8601)