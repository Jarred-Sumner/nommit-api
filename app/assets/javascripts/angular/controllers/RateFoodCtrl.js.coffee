@nommit.controller 'RateFoodCtrl', ($scope, Sessions, Foods, $rootScope, Users, $timeout, Orders, $state) ->
  $scope.closeOnEsc = (event) ->

  $scope.close = ->
    $rootScope.$emit "HideRateFood"
    clearData()
  $scope.incrementTip = ->
    $scope.tip = $scope.tip + 1
  $scope.decrementTip = ->
    $scope.tip = $scope.tip - 1
  $scope.enableDone = ->
    $scope.rated = true
  $scope.rate = ->
    if $scope.rated
      $scope.rating = true
      Orders.update id: $scope.order.id,
        rating: $scope.order.rating
        state_id: 3
        tip_in_cents: $scope.tip * 100
      , (order) ->
        $scope.close()
      , (error) ->
        $scope.error = error.data.message
        $scope.rating = false

  clearData = ->
    $scope.error = null
    $scope.order = null
    $scope.food = null
    $scope.seller = null
    $scope.courier = null
    $scope.tip = 0
    $scope.rating = false
    $scope.rated = false

  $rootScope.$on "RateFood", (event, data) ->
    clearData()
    order = new Orders(data.order)
    $scope.order = order
    $scope.food = order.food
    $scope.seller = order.food.seller
    $scope.courier = order.courier
