@nommit.factory 'Orders', ($resource, Users) ->
  $resource "api/v1/orders/:id", @id,
    update:
      method: "PUT"
