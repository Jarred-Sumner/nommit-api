@nommit.factory 'Orders', ($resource, Users, DeliveryPlaces) ->
  Orders = $resource "api/v1/orders/:id", @id,
    update:
      method: "PUT"

  Orders::isCancelled = ->
    @state_id == -1
  Orders::isActive = ->
    @state_id == 0
  Orders::isArrived = ->
    @state_id == 1
  Orders::isDelivered = ->
    @state_id == 2
  Orders::isRated = ->
    @state_id == 3

  Orders::deliveryPlace = ->
    @_deilveryPlace ||= new DeliveryPlaces(@delivery_place)

  Orders::isLate = ->
    this.deliveredAt() < new Date()
  Orders::deliveredAt = ->
    @_deliveredAt ||= new Date(@delivered_at)

  Orders::cost = ->
    @price_charged_in_cents / 100.0

  Orders::isPending = ->
    this.isArrived() || this.isActive()

  Orders
