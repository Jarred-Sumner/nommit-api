json.array! @shifts, partial: "api/v1/shifts/shift", as: :shift, locals: { show_courier: true}
