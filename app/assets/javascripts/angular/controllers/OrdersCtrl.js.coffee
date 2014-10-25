@nommit.controller 'OrdersCtrl', ($scope, Foods, Places, $rootScope, Orders, Sessions) ->
  $rootScope.$emit("requireLogin") unless Sessions.isLoggedIn()

  refreshOrders = ->
    $scope.fetchedOrders = false
    $scope.orders = Orders.query ->
      $scope.fetchedOrders = true
    , ->
      $scope.fetchedOrders = true

  $rootScope.$on "CurrentUser", ->
    refreshOrders()
  refreshOrders()
