@nommit.controller "OrderCtrl", ($scope, $stateParams) ->
  $scope.order =
    price_id: null
    place_id: $scope.place.id
    food_id: $scope.food_id
    promo_code: null
  if !$scope.user
    $scope.requireLogin($scope.food, $scope.place)
