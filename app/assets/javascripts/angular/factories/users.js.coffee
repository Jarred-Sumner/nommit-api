@nommit.factory 'Users', ['$resource', ($resource) ->
  User = $resource "api/v1/users/:id", "id" : @id,
    update:
      method: "PUT"
    promo:
      method: "POST"
      url: "api/v1/users/:id/promos"

  User::isActivated = ->
    @state_id == 1
  User::isRegistered = ->
    @state_id == 0

  User::credit = ->
    @credit_in_cents > 0 ? @credit_in_cents / 100 : 0

  User
]
