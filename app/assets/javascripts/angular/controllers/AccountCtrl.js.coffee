@nommit.controller 'AccountCtrl', ($scope, Users, $rootScope, Sessions) ->
  $rootScope.$emit "requireLogin" unless Sessions.isLoggedIn()
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
    $scope.fetchedUser = true

  $scope.editPayment = ->
    
