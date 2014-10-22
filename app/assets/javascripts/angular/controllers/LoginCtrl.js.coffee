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
          $scope.error = null
        else
          $rootScope.$emit("HideLogin", callback: $scope.loginCallback)
          $scope.error = null
    else
      $scope.error = "To continue, please login with Facebook."


  $scope.login = ->
    $scope.isLoggingIn = true
    if loginStatus.status == "connected"
      loginSucceeded(loginStatus)
    else
      Facebook.login(loginSucceeded)

  $rootScope.$on "requireLogin", (event, obj) ->
    if obj.callback
      $scope.loginCallback = obj
    if obj.error
      $scope.error = "To continue, please login with Facebook"
