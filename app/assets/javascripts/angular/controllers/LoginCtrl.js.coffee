@nommit.controller 'LoginCtrl', ($scope, $rootScope, Facebook, Sessions) ->
  loginStatus = null
  Facebook.getLoginStatus (response) ->
    loginStatus = response

  loginSucceeded = (response) ->
    if response.status == "connected"
      Sessions.login response.authResponse, (user) ->
        $scope.isLoggingIn = false
        if user.isRegistered()
          $rootScope.$emit("requireActivation", callback: $scope.loginCallback)
        else
          $rootScope.$emit("HideLogin", callback: $scope.loginCallback)
    else


  $scope.login = ->
    $scope.isLoggingIn = true
    if loginStatus.status == "connected"
      loginSucceeded(loginStatus)
    else
      Facebook.login(loginSucceeded)

  $rootScope.$on "requireLogin", (event, obj) ->
    if obj.callback
      $scope.loginCallback = obj
