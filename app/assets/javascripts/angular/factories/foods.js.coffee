@nommit.factory 'Foods', ['$resource', ($resource) ->
  Foods = $resource 'api/v1/foods/:id', id: '@id'

  Foods::price = ->
    @prices[@quantity - 1].price

  # angular.extend Foods,
  #   getPlaces:

  Foods
]
