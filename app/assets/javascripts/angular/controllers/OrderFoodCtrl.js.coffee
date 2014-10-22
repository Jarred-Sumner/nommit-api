@nommit.controller 'OrderFoodCtrl', ($scope, Sessions, Places, $rootScope, Users, $timeout, Orders) ->
  $scope.close = ->
    $rootScope.$emit "HideOrderFood"
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
  $rootScope.$on "OrderFood", (event, data) ->
    food = data.food

    $scope.food = food
    $scope.place = data.place
    $scope.price = food.prices[food.quantity - 1].price


  $scope.placeOrder = ->
    $scope.placing = true
    price = $scope.food.prices[$scope.food.quantity - 1]
    params =
      price_id: price.id
      food_id: $scope.food.id
      place_id: $scope.place.id
    params.promo_code = $scope.food.promo if $scope.food.promo
    success = (order) ->
      $scope.error = null
      $scope.placing = false
    error = (error) ->
      $scope.placing = false
      $scope.error = error.data.message
    Orders.save(params, success, error)
