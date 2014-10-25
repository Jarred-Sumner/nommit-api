@nommit.controller 'OrdersCtrl', ($scope, Foods, Places, $rootScope, Orders, Sessions, $interval) ->
  $rootScope.$emit("requireLogin") unless Sessions.isLoggedIn()

  refreshOrders = (silent) ->
    $scope.fetchedOrders = false unless silent
    Orders.query (orders) ->
      $scope.orders = orders
      $scope.fetchedOrders = true
    , ->
      $scope.fetchedOrders = true

  $rootScope.$on "CurrentUser", ->
    refreshOrders(false)

  # Refresh orders every 10 seconds.
  refresherPromise = $interval ->
    refreshOrders(silent = true)
  , 10000

  $scope.$on "$destroy", ->
    console.log("LAY")
    $interval.cancel(refresherPromise)
