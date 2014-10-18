@nommit.factory 'DeliveryPlaces', ['$resource', 'Foods', ($resource, Foods) ->
  DeliveryPlaces = $resource('api/v1/delivery_places/:id', id: '@id')
  DeliveryPlaces
]
