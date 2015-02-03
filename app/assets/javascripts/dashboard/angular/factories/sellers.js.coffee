@nommit.factory 'Sellers', ($resource) ->
  Sellers = $resource 'api/v1/sellers/:id', id: '@id'