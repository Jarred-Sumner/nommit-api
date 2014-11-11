@nommit.controller "FoodsCtrl", ($state, Foods, Places, $stateParams, DeliveryPlaces, $scope) ->
  retrieveFoods = ->
    Foods.query (foods) ->
      $scope.foods = _.map foods, (food) ->
        food.quantity = 1
        new Foods(food)

  retrievePlace = (id) ->
    Places.get id: id, (place) ->

      $scope.place = new Places(place)

      # There are way smarter ways to do this.
      # But, given that we're only dealing with a max of...3 foods?
      # It really does not matter at all.
      $scope.foods = _.chain(place.delivery_places)
        # Get the delivery places we can order from
        .select (dp) ->
          dp = new DeliveryPlaces(dp)
          dp.isOrderable()
        # Grab their foods
        .map (dp) ->
          dp.foods
        # Get rid of the array of arrays of foods
        .flatten()
        # Turn them into food objects
        .map (food) ->
          food = new Foods(food)
          food.quantity = 1
          food
        # Return only the foods we can order
        .select (food) ->
          console.log(food.isOrderable())
          food.isOrderable()
        # Remove duplicates, just in case.
        .uniq()
        .value()
      console.log($scope.foods)



  if $stateParams.place_id
    retrievePlace($stateParams.place_id)
  else
    retrieveFoods()
