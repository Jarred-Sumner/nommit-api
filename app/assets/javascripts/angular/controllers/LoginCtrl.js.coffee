@nommit.controller 'LoginCtrl', ($scope, $rootScope, Facebook, Sessions) ->
  loginSucceeded = (response) ->
    if response.status == "connected"
      Sessions.login response.authResponse, (user) ->
        $scope.isLoggingIn = false
        $rootScope.$emit("requireActivation") if user.isRegistered()
    else

  $scope.login = ->
    $scope.isLoggingIn = true
    Facebook.getLoginStatus (response) ->
      if response.status == "unknown"
        Facebook.login(loginSucceeded)
      else
        loginSucceeded(response)
