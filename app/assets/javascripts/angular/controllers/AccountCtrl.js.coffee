@nommit.controller 'AccountCtrl', ($scope, Users, $rootScope, Sessions) ->
  $rootScope.$emit "requireLogin" unless Sessions.isLoggedIn()
  Sessions.currentUser (user) ->
    $scope.user = user
    $scope.fetchedUser = true

  $scope.editPayment = ->
