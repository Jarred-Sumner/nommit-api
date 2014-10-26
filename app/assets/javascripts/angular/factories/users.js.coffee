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
    if @credit_in_cents > 0 then @credit_in_cents / 100 else 0

  User
]
