@nommit.factory 'Users', ['$resource', ($resource) ->
  Users = $resource "api/v1/users", "id" : @id

  Users
]
