@nommit.factory 'Schools', ($resource) ->
  Schools = $resource 'api/v1/schools/:id', id: '@id'