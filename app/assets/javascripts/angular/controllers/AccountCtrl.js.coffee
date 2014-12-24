@nommit.controller "AccountCtrl", ($scope, Users, $rootScope, Sessions, $timeout, $state) ->
  $state.go "foods" unless Sessions.isLoggedIn()

  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user

  $scope.logout = ->
    Sessions.setSessionID(null)
    Sessions.setCurrentUser(null)
    $rootScope.user = null
    location.pathname = "/logout"
  $scope.applyPromo = ->
    $scope.isApplying = true
    $scope.isApplyingPromo = true
    Users.promo id: $scope.user.id,
      $scope.promo,
    , (user) ->
      $scope.isApplying = false
      $scope.didApply = true

      Sessions.setCurrentUser(user)
      $scope.user = user

      $timeout ->
        $scope.reset()
      , 1500

    , (error) ->
      $scope.isApplying = false
      $scope.error = error.data.message

  $scope.reset = ->
    $scope.didApply = false
    $scope.isApplying = false
    $scope.isApplyingPromo = false
    $scope.error = null
    $scope.promo =
      code: null

  $scope.reset()
