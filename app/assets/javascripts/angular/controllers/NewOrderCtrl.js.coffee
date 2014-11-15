@nommit.controller "NewOrderCtrl", ($scope, $stateParams, Orders, $state, $rootScope) ->
  $scope.order =
    price_id: $scope.food.prices[0].id
    place_id: $scope.place.id
    food_id: $scope.food.id
    promo_code: null
  if !$scope.user
    $scope.requireLogin($scope.food, $scope.place)

  $scope.price = ->
    $scope.food.priceByID($scope.order.price_id)

  $scope.placeOrder = ->
    Orders.save $scope.order, (order) ->
      $rootScope.order = order
      $state.go("orders", { order_id: order.id })
