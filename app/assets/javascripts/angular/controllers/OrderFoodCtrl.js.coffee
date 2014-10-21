@nommit.controller 'OrderFoodCtrl', ($scope, Sessions, Places, $rootScope, Users, $timeout) ->
  $scope.close = ->
    $rootScope.$emit "HideOrderFood"
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user

  $rootScope.$on "OrderFood", (event, data) ->
    food = data.food

    $scope.food = food
    $scope.place = data.place
    $scope.price = food.prices[food.quantity - 1].price
