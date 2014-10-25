@nommit.controller 'ActivateCtrl', ($scope, Sessions, Places, $rootScope, Users, $timeout) ->
  $scope.close = (cb) ->
    $rootScope.$emit("HideActivation", callback: cb)
  $rootScope.$on "requireActivation", (event, cb) ->
    $scope.callback = cb
    $scope.error = "To continue, activate your account."
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
      # Wrap in timeout to fix issues with Angular context vs Window context
      $timeout( ->
        if response.error
          $scope.error = response.error.message
          $scope.isActivating = false
        else
          success = (user) ->
            Sessions.setCurrentUser(user)
            $scope.isActivating = false
            $scope.close ->
              $rootScope.$emit("requireValidation", $scope.callback)
          error = (error) ->
            $scope.error = error.data.message
            $scope.isActivating = false
          params =
            state_id: 1
            phone: $scope.activation.phone
            stripe_token: response.id
          Users.update(id: $scope.user.id, params, success, error)
      , 1)
