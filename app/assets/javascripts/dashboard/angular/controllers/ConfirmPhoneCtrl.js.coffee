@nommit.controller "ConfirmPhoneCtrl", ($scope, $rootScope, Users, Sessions, $timeout) ->
  $scope.reset = ->
    $scope.error = null
    $scope.didConfirm = false
    $scope.isConfirming = false
    $scope.confirm_code = null

  $scope.confirm = ->
    $scope.isConfirming = true
    Users.update id: $scope.user.id,
      confirm_code: $scope.confirm_code
    , (user) ->
      $rootScope.user = new Users(user)
      Sessions.setCurrentUser(user)
      $scope.didConfirm = true
      $timeout ->
        $rootScope.hideConfirmPhone()
        $scope.reset()
      , 250

    , (error) ->
      $scope.error = error.data.message
