@nommit.controller 'RateFoodCtrl', ($scope, Sessions, Foods, $rootScope, Users, $timeout, Orders, $state) ->
  $scope.closeOnEsc = (event) ->

  $scope.close = ->
    $rootScope.$emit "HideRateFood"
    clearData()
  $scope.incrementTip = ->

  $scope.decrementTip = ->

  $scope.rate = ->

  clearData = ->
    $scope.error = null
    $scope.order = null
    $scope.food = null
    $scope.seller = null
    $scope.courier = null
    $scope.rating = false

  $rootScope.$on "RateFood", (event, data) ->
    order = new Orders(data.order)
    $scope.order = order
    $scope.food = order.food
    $scope.seller = order.food.seller
    $scope.courier = order.courier
