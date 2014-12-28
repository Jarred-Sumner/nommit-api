@nommit.factory "Shifts", ($resource, Users, DeliveryPlaces, Orders) ->
  Shifts = $resource "api/v1/shifts/:id", @id,
    update:
      method: "PUT"

  Shifts::revenue = ->
    @revenue_generated_in_cents / 100
  Shifts::isOngoing = ->
    @state_id == 0 || @state_id == 1

  Shifts::deliveryPlaces = ->
    if @_deliveryPlaces then return @_deliveryPlaces

    dps = {}
    for o in @orders
      order = new Orders(o)
      continue unless order.isPending()
      dps[order.deliveryPlace().id] ||= order.deliveryPlace()
      dps[order.deliveryPlace().id].pendingOrders().push(order)

    @_deliveryPlaces = _.values(dps)

  Shifts
