@nommit.factory 'Promos', ['$resource', ($resource) ->
  Promos = $resource 'api/v1/promos/:id', id: '@id'

  Promos::isExpired = ->
    if @expiration then new Date(@expiration) < new Date() else false
  # angular.extend Foods,
  #   getPlaces:

  Promos
]
