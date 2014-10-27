@nommit.controller 'FoodsCtrl', ($scope, Foods, Places, $rootScope, Sessions, $stateParams, $http) ->
  $scope.orderingFood = false
  $scope.price = (food, quantity) ->
    if quantity
      food.prices[quantity - 1].price
    else
      food.prices[0].price
  $scope.progressForFood = (food) ->
    (food.order_count / food.goal) * 100
  setPlace = (place) ->
    if place || window.settings.placeID()
      Places.get id: window.settings.placeID(), (place) ->
        $scope.place = place

        $scope.foods = _.chain(place.delivery_places)
          .map (deliveryPlace) ->
            _.filter deliveryPlace.foods, (food) ->
              food.rating = Math.round(food.rating)
              food.quantity = 1
              food.state_id == 0
          .flatten()
          .value()
        $scope.fetchedFoods = true
    else
      $scope.place = null
      $scope.foods = []
      $scope.fetchedFoods = true

  $rootScope.$on "placeIDChanged", (event) ->
    setPlace()
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user

  applyPendingPromo = ->
    unless _.str.isBlank($stateParams.i)
      promo =
        code: $stateParams.i
        autoapply: true
      $http.post("/api/v1/users/#{$scope.user.id}/promos", promo).success (user) ->
        Sessions.setCurrentUser(user)

  Sessions.currentUser (user) ->
    $scope.user = user
    applyPendingPromo() if user


  setPlace()

  $rootScope.$on "HideOrderFood", ->
    $scope.orderingFood = false
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
  $scope.order = (food) ->
    if $scope.user
      if $scope.user.isActivated()
        $scope.orderingFood = true
        $rootScope.$emit "OrderFood", food: food, place: $scope.place, user: $scope.user
      else if $scope.user.isRegistered()
        $rootScope.$emit "requireActivation",
          callback: $scope.order
          object: food
    else
      $rootScope.$broadcast "requireLogin",
        callback: $scope.order
        object: food
        error: true
