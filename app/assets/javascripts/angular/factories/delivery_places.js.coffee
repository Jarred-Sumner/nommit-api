@nommit.factory 'DeliveryPlaces', ['$resource', 'Foods', ($resource, Foods) ->
  DeliveryPlaces = $resource('api/v1/delivery_places/:id', id: '@id')

  DeliveryPlaces::isOrderable = ->
    # 0 - ready
    # 1 - arrived
    # 4 - pending
    states = [0,1,4]
    states.indexOf(@state_id) > -1
  DeliveryPlaces::eta = ->
    @_eta ||= new Date(@arrives_at)
  DeliveryPlaces::pendingOrders = ->
    @_pendingOrders ||= []



  DeliveryPlaces
]
