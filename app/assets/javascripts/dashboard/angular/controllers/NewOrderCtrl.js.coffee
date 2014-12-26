@nommit.controller "NewOrderCtrl", ($scope, $stateParams, Orders, $state, $rootScope) ->
  $scope.order =
    price_id: $scope.food.prices[0].id
    place_id: $scope.place.id
    food_id: $scope.food.id
    promo_code: null

  $scope.quantity = ->
    $scope.food.quantityByID($scope.order.price_id)
  $scope.price = ->
    $scope.food.priceByID($scope.order.price_id)

  $scope.placeOrder = ->
    $scope.isOrdering = true
  $scope.confirmOrder = ->
    $scope.isConfirmed = true
    $scope.isPlacing = true
    Orders.save $scope.order, (order) ->
      $scope.isPlacing = false
      $rootScope.order = order
      $state.go("dashboard.orders", { order_id: order.id })
    , (error) ->
      $scope.isPlacing = false
      $scope.error = error.data.message
  $scope.reset = ->
    $scope.isOrdering = false
    $scope.isPlacing = false
    $scope.isConfirmed = false
    $scope.error = null

  $scope.reset()
