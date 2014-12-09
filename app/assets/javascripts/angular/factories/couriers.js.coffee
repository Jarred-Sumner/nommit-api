@nommit.factory "Couriers", ($resource) ->
  Courier = $resource 'api/v1/couriers', id: '@id',
    me:
      isArray: true
      url: "api/v1/couriers/me"
