@nommit.factory 'Users', ['$resource', ($resource) ->
  Users = $resource "api/v1/users", "id" : @id

  angular.extend Users,
    isActivated: ->
      @state_id == 1
    isRegistered: ->
      @state_id == 0

  Users
]
