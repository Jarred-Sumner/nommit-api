@nommit.controller "OrdersCtrl", ($scope, Orders, $rootScope)  ->
  loadOrders = ->
    $scope.isLoadingOrders = true
    Orders.query state_id: "pending", (orders) ->
      $scope.isLoadingOrders = false
      $scope.orders = orders
  $rootScope.$on "ToggledDashboard", (event, isVisible) ->
    if isVisible
      loadOrders()
    else
      $scope.orders = []
      $scope.isLoadingOrders = false
  loadOrders()
