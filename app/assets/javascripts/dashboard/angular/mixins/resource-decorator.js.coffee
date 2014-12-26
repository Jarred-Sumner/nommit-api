window.ResourceDecorator = (Resource, decorator) ->
  methodNames = ['get', 'query', 'update']
  _.forEach methodNames, (methodName) ->
    method = Resource[methodName]
    Resource[methodName] = ->
      method.apply(Resource, arguments).$promise.then()

    $method = Resource::[methodName]
    Resource::[methodName] = ->
      $method.apply(this, arguments).$promise.$then decorator
  Resource
