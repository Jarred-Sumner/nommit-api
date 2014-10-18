@nommit.factory 'Foods', ['$resource', ($resource) ->
  Foods = $resource 'api/v1/foods/:id', id: '@id'

  # angular.extend Foods,
  #   getPlaces:

  Foods
]
