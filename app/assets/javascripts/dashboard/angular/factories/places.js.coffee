@nommit.factory 'Places', ['$resource', 'DeliveryPlaces', ($resource, DeliveryPlaces) ->
  Places = $resource('api/v1/places/:id', id: '@id')
]
