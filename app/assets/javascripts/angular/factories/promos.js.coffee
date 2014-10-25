@nommit.factory 'Promos', ['$resource', ($resource) ->
  Promos = $resource 'api/v1/promos/:id', id: '@id'

  Promos::isExpired = ->
    new Date(@expiration) < new Date()
  # angular.extend Foods,
  #   getPlaces:

  Promos
]
