@nommit.controller 'OrderFoodCtrl', ($scope, Sessions, Foods, $rootScope, Users, $timeout, Orders, $state, Promos) ->
  resetData = ->
    $scope.food = null
    $scope.place = null
    $scope.price = null
    $scope.error = null
    $scope.info = null
    $scope.user = null
    $scope.isPromoUsable = false
    $scope.placing = false
  setVanillaPrice = ->
    price = $scope.food.prices[$scope.food.quantity - 1].price * 100 - $scope.user.credit_in_cents
    if price > 0
      $scope.price = price / 100
    else
      $scope.price = 0

  priceCheck = (food, user) ->
    success = (promo) ->
      promo = new Promos(promo)
      if promo.active && promo.usable
        price = food.price_in_cents - promo.discount_in_cents - $scope.user.credit_in_cents
        if price > 0
          price = price / 100
        else
          price = 0
        $scope.price = price
        $scope.isPromoUsable = true
      else
        setVanillaPrice()
        if promo.active && !promo.usable
          if promo.referral
            $scope.info = "Promo only usable for first order"
          else
            $scope.info = "Promo already applied to your account"
        else if promo.isExpired()
          $scope.info = "Promo has expired"
        else
          $scope.info = "Promo cannot be used"
      $scope.priceChecking = false
    failure = (error) ->
      $scope.priceChecking = false
      $scope.info = error.data.message
      setVanillaPrice()
    Promos.get(id: food.promo, success, failure)


  $scope.close = ->
    resetData()
    $rootScope.$emit "HideOrderFood"
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
  $rootScope.$on "OrderFood", (event, data) ->
    resetData()
    food = new Foods(data.food)

    $scope.food = food
    $scope.place = data.place
    $scope.user = data.user
    if food.promo
      $scope.priceChecking = true
      priceCheck(food)
    else
      setVanillaPrice()
  $scope.placeOrder = ->
    $scope.placing = true
    price = $scope.food.prices[$scope.food.quantity - 1]
    params =
      price_id: price.id
      food_id: $scope.food.id
      place_id: $scope.place.id
    params.promo_code = $scope.food.promo if $scope.food.promo && $scope.isPromoUsable
    success = (order) ->
      resetData()
      $state.transitionTo("orders")
    error = (error) ->
      $scope.placing = false
      $scope.info = null
      $scope.error = error.data.message
    Orders.save(params, success, error)
