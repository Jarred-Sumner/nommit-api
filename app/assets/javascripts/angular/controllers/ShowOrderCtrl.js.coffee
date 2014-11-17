@nommit.controller "ShowOrderCtrl", ($scope, Orders, $rootScope, $stateParams, $interval) ->
  $scope.order = $rootScope.order
  delete $rootScope.order

  $scope.food = $scope.order.food
  $scope.place = $scope.order.place
  $scope.courier = $scope.order.courier
  $scope.seller = $scope.order.food.seller

  refreshOrder = ->
    Orders.get id: $stateParams.order_id, (order) ->
      $scope.order = new Orders(order)

  startTimer = ->
    stopTimer()
    $scope.timer = $interval ->
      refreshOrder()
    , 10000
  stopTimer = ->
    if $scope.timer
      $interval.cancel($scope.timer)
      delete $scope.timer

  $scope.call = ->
    location.href = "tel://#{$scope.courier.user.phone}"

  startTimer()
