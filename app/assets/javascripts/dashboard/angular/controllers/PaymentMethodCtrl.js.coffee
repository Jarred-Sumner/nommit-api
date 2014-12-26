@nommit.controller "PaymentMethodCtrl", ($scope, Users, $timeout, Sessions, $rootScope, $state) ->
  $scope.startUpdating = ->
    $scope.isUpdating = true

    if $scope.cardForm.$invalid
      $scope.error = "Payment information is invalid, please re-enter it and try again."
    else
      $scope.isUpdating = true
  $scope.update = (status, response) ->
    return false if $scope.cardForm.$invalid
    $scope.isUpdating = true
    if status == 200
      # Debounce Stripe's context switching issue
      $timeout ->
        Users.update id: $scope.user.id,
          stripe_token: response.id
        , (user) ->
          $scope.didSave = true

          $rootScope.user = new Users(user)
          $scope.user = $rootScope.user
          Sessions.setCurrentUser(user)

          $timeout ->
            $scope.reset()
            $state.go("dashboard.account")
          , 250

      , 1
    else
      $scope.error = response.error.message

  $scope.submitForm = ->



  $scope.reset = ->
    $scope.isUpdating = false
    $scope.error = null
    $scope.didSave = false
    $scope.expiry = null
    $scope.number = null
    $scope.cvc = null
    $scope.type = null
  $scope.reset()
