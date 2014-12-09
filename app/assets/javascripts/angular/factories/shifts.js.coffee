@nommit.factory "Shifts", ($resource, Users, DeliveryPlaces) ->
  Shifts = $resource "api/v1/shifts/:id", @id,
    update:
      method: "PUT"

  Shifts::revenue = ->
    @revenue_generated_in_cents / 100
  Shifts::isOngoing = ->
    @state_id == 0 || @state_id == 1

  Shifts::deliveryPlaces = ->
    @_deliveryPlaces ||= _.map @delivery_places, (deliveryPlace) ->
      new DeliveryPlaces(deliveryPlace)
  Shifts::activeDeliveryPlaces = ->
    return @_activeDeliveryPlaces if @_activeDeliveryPlaces
    @_activeDeliveryPlaces = _.chain(this.deliveryPlaces())
      .select (deliveryPlace) ->
        states = [0, 1, 2]
        states.indexOf(deliveryPlace.state_id) > -1
      .sortBy (deliveryPlace) ->
        deliveryPlace.index
      .value()

  Shifts
