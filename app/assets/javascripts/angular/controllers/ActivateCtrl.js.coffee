@nommit.controller 'ActivateCtrl', ($scope, Sessions, Places, $rootScope, Users) ->
  $scope.close = ->
    $rootScope.$emit("HideActivation")
  $rootScope.$on "requireActivation", (event, obj) ->
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user

  $scope.payment =
    card: null
    expiry: null
    cvc: null
  $scope.activation =
    stripe_token: null
    phone: null
    state_id: 1

  $scope.activate = ->
    $scope.isActivating = true
    window.Stripe.card.createToken
      number: $scope.payment.card
      cvc: $scope.payment.cvc
      exp_month: $scope.payment.expiry.split("/")[0]
      exp_year: $scope.payment.expiry.split("/")[1]
    , (status, response) ->
      console.log(response)
      if status == 200
        Users.update
          id: $scope.user.id
          state_id: 1
          phone: $scope.activation.phone
          stripe_token: response.token
      else
        console.log(response)
        # TODO: Handle error
