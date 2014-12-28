@nommit.controller "OrdersCtrl", ($scope, Orders, $rootScope, Sessions, $http)  ->
  loadOrders = ->
    $scope.isLoadingOrders = true
    # Work-around for issue where 
    # It tries to fire this request before session ID is loaded on first login
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
