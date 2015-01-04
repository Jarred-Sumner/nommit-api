@nommit.controller "PaymentMethodCtrl", ($scope, Users, $timeout, Sessions, $rootScope, $state) ->
  $scope.save = ->
    $scope.isUpdating = true

    if $scope.cardForm.$invalid
      $scope.error = "Payment information is invalid, please re-enter it and try again."
    else
      $scope.isUpdating = true
  $scope.update = (status, response) ->
    return false if $scope.cardForm.$invalid
    $scope.isUpdating = true

    if status == 200

      success = (user) ->
        $scope.didSave = true
        Sessions.setCurrentUser(user)

        $timeout ->
          $scope.reset()
          $scope.didSetPaymentMethod()
        , 250
      error = (error) ->
        $scope.error = error.data.message

      # Fix the $digest/$apply cycle crap
      $timeout ->
        Users.update(id: $scope.user.id,
          stripe_token: response.id
        ).$promise.then(success, error)

    else
      console.log(response)
      $scope.error = response.error.message

  $scope.reset = ->
    $scope.isUpdating = false
    $scope.error = null
    $scope.didSave = false
    $scope.expiry = null
    $scope.number = null
    $scope.cvc = null
    $scope.type = null
  $scope.reset()
