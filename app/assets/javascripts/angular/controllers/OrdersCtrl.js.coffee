@nommit.controller 'OrdersCtrl', ($scope, Foods, Places, $rootScope, Orders, Sessions) ->
  $rootScope.$emit("requireLogin") unless Sessions.isLoggedIn()

  $scope.fetchedOrders = false
  $rootScope.$on "CurrentUser", ->
    $scope.orders = Orders.query ->
      $scope.fetchedOrders = true
