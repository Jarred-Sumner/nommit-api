@nommit.controller 'ConfirmPhoneCtrl', ($scope, Sessions, Places, $rootScope, Users, $timeout) ->
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
  $rootScope.$on "requireValidation", (event, obj) ->
    $scope.callback = obj
  $scope.close = ->
    $rootScope.$emit("HideConfirmPhone")


  $scope.confirm = ->
    $scope.isConfirming = true
    params =
      confirm_code: $scope.code
    success = (user) ->
      $scope.isConfirming = false
      Sessions.setCurrentUser(user)
      $rootScope.$emit "HideConfirmPhone", $scope.callback
    error = (error) ->
      $scope.error = error.data.message
      $scope.isConfirming = false
    Users.update(id: $scope.user.id, params, success, error)
