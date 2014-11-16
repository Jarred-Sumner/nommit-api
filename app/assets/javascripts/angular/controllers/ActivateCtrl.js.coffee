@nommit.controller "ActivateCtrl", ($scope, Users, Sessions, $rootScope, $timeout) ->
  $scope.startActivating = ->
    $scope.isActivating = true

    if $scope.activateForm.$invalid
      $scope.error = "Please re-enter your information and try again"
    else
      $scope.isActivating = true
  $scope.activate = (status, response) ->
    return false if $scope.activateForm.$invalid
    $scope.isActivating = true

    if status == 200
      $timeout ->
        Users.update id: $scope.user.id,
          stripe_token: response.id
          phone: $scope.phone
          email: $scope.email
        , (user) ->
          Sessions.setCurrentUser(user)
          $rootScope.user = new Users(user)
          $rootScope.requireConfirm()
          $scope.reset()
        , (error) ->
          $scope.error = error.data.message
      , 1
    else
      $scope.error = response.error.message

  $scope.reset = ->
    $scope.isActivating = false
    $scope.error = null
    $scope.card = null
    $scope.expiry = null
    $scope.phone = null
    $scope.email = $scope.user.email
    $scope.cvc = null

  $scope.reset()
