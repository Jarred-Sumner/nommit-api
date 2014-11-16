@nommit.controller "FoodsCtrl", ($state, Foods, Places, $stateParams, DeliveryPlaces, $scope, $timeout, $rootScope, Users) ->
  didAutoPresentPlaces = false

  $scope.notifyMe = ->
    $scope.notifying = true
    Users.update id: $scope.user.id,
      push_notifications: "reset"
    , (user) ->
      $scope.notified = true
      $timeout ->
        $scope.notifying = false
      , 250
    , (error) ->
      $scope.notified = true
      $timeout ->
        $scope.notifying = false
      , 250


  $scope.order = (food) ->
    $rootScope.food = food
    $rootScope.place = $scope.place
    $state.go("foods.order", { place_id: $rootScope.place.id, food_id: food.id })

  retrieveFoods = ->
    Foods.query (foods) ->
      $scope.foods = _.chain(foods)
        .map (food) ->
          food.quantity = 1
          new Foods(food)
        # Make the orderable foods appear at the top
        .sortBy (food) ->
          food.startDate()
        .reverse()
        .value()


      # Auto-show places
      # But, don't do immediately because browsers are slow.
      # Wait 500ms
      $timeout ->
        unless didAutoPresentPlaces
          for food in $scope.foods
            if food.isOrderable()
              $state.go("foods.places")
              didAutopresentPlaces = true
      , 500

  retrievePlace = (id) ->
    Places.get id: id, (place) ->
      window.settings.setPlaceID(id)
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
          food.isOrderable()
        # Remove duplicates, just in case.
        .uniq()
        .value()



  if $stateParams.place_id
    retrievePlace($stateParams.place_id)
  else
    retrieveFoods()
