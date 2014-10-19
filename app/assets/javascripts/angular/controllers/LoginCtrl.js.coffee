@nommit.controller 'LoginCtrl', ($scope, $rootScope, Facebook, Sessions) ->
  loginStatus = null
  Facebook.getLoginStatus (response) ->
    loginStatus = response

  loginSucceeded = (response) ->
    if response.status == "connected"
      Sessions.login response.authResponse, (user) ->
        $scope.isLoggingIn = false
        $rootScope.$emit("requireActivation") if user.isRegistered()
    else


  $scope.login = ->
    $scope.isLoggingIn = true
    if loginStatus.status == "connected"
      loginSucceeded(loginStatus)
    else
      Facebook.login(loginSucceeded)
