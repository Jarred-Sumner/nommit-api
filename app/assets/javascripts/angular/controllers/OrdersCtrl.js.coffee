@nommit.controller 'OrdersCtrl', ($scope, Foods, Places, $rootScope, Orders, Sessions, $interval) ->
  $rootScope.$emit("requireLogin") unless Sessions.isLoggedIn()

  clearData = ->
    $scope.fetching = false
    $scope.fetchedOrders = false

  startRefreshing = ->
    $interval.cancel($scope.refresherPromise) if $scope.refresherPromise
    $scope.refresherPromise = $interval ->
      refreshOrders()
    , 10000
  refreshOrders = ->
    $scope.fetching = true
    Orders.query().$promise.then (orders) ->
      $scope.orders = orders
      $scope.fetching = false

  startRefreshing()

  $scope.orders = Orders.query (orders) ->
    $scope.fetching = false
    $scope.fetchedOrders = true
  , ->
    $scope.fetching = false
    $scope.fetchedOrders = true





  $rootScope.$on "CurrentUser", ->
    refreshOrders()

  $rootScope.$on "$stateChangeSuccess", (event, state) ->
    if state.name == "orders"
      clearData()
      # Refresh orders every 10 seconds.
      $interval.cancel($scope.refresherPromise) if $scope.refresherPromise
      startRefreshing()
    else
      clearData()
      $interval.cancel($scope.refresherPromise) if $scope.refresherPromise
  clearData()
