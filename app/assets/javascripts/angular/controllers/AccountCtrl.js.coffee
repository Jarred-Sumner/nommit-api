@nommit.controller 'AccountCtrl', ($scope, Users, $rootScope, Sessions, $http) ->
  $rootScope.$emit "requireLogin" unless Sessions.isLoggedIn()
  $scope.promo =
    code: ""
  $rootScope.$on "$stateChangeSuccess", ->
    $scope.error = null

  Sessions.currentUser (user) ->
    $scope.user = user
    $scope.fetchedUser = true
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user

  $scope.editPayment = ->

  $scope.applyPromo = ->
    $scope.applying = true
    $http.post("api/v1/users/#{$scope.user.id}/promos", $scope.promo).success( (user) ->
      Sessions.setCurrentUser(user)
      $scope.applying = false
      $scope.error = null
    ).error((error) ->
      $scope.applying = false
      $scope.error = error.message
    )
