@nommit.controller 'FoodsCtrl', ($scope, Foods, Places, $rootScope) ->
  $scope.price = (food, quantity) ->
    if quantity
      food.prices[quantity - 1].price
    else
      food.prices[0].price
  $scope.progressForFood = (food) ->
    (food.order_count / food.goal) * 100
  setPlace = ->
    Places.get id: window.settings.placeID(), (place) ->
      $scope.place = place

      $scope.foods = _.chain(place.delivery_places)
        .map (deliveryPlace) ->
          _.map deliveryPlace.foods, (food) ->
            food.rating = Math.round(food.rating )
            food.quantity = 1
            food
        .flatten()
        .value()

  $rootScope.$on "placeIDChanged", (event) ->
    setPlace()

  setPlace()
