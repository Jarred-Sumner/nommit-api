@nommit.controller "OrdersCtrl", ($scope, Orders, $rootScope, Sessions)  ->
  loadOrders = ->
    if Sessions.isLoggedIn()
      $scope.isLoadingOrders = true
      Orders.query state_id: "pending", (orders) ->
        $scope.isLoadingOrders = false
        $scope.orders = orders
      , ->
        $scope.isLoadingOrders = false
  $rootScope.$on "ToggledDashboard", (event, isVisible) ->
    if isVisible
      $scope.orders = []
      loadOrders()
    else
      $scope.orders = []
      $scope.isLoadingOrders = false

  loadOrders()
