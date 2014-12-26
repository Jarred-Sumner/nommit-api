@nommit.controller "AccountCtrl", ($scope, Users, $rootScope, Sessions, $timeout, $state, $http) ->
  $scope.toggleEmailSubscribe = ->
    if $scope.user.subscription.email then state = 0 else state = 1
    $scope.isSaving = true
    $http
      .post("api/v1/users/#{$scope.user.id}/subscription", email: state)
      .success((user) ->
        $scope.user.subscription.email = state == 1
        $scope.didSave = true
        $timeout ->
          $scope.reset()
        , 750
      ).error((error) ->
        $scope.error = error.data.message
      )
  $scope.toggleSMSSubscribe = ->
    if $scope.user.subscription.sms then state = 0 else state = 1
    $scope.isSaving = true
    $http
      .post("api/v1/users/#{$scope.user.id}/subscription", sms: state)
      .success((user) ->
        $scope.user.subscription.sms = state == 1
        $scope.didSave = true
        $timeout ->
          $scope.reset()
        , 750
      ).error((error) ->
        $scope.error = error.data.message
      )


  $scope.logout = ->
    Sessions.setSessionID(null)
    Sessions.setCurrentUser(null)
    $rootScope.user = null
    location.pathname = "/logout"
  $scope.applyPromo = ->
    $scope.isSaving = true
    Users.promo id: $scope.user.id,
      $scope.promo,
    , (user) ->
      $scope.isSaving = false
      $scope.didSave = true

      Sessions.setCurrentUser(user)
      $scope.user = user

      $timeout ->
        $scope.reset()
      , 1500

    , (error) ->
      $scope.error = error.data.message

  $scope.reset = ->
    $scope.didSave = false
    $scope.isSaving = false
    $scope.error = null
    $scope.promo =
      code: null

  $scope.reset()
