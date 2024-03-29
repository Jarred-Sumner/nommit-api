@nommit.controller "DeliveryCtrl", ($scope, Shifts, Orders, $interval, $timeout, $state, $rootScope) ->
  $rootScope.$on "$stateChangeSuccess", ->
    $interval.cancel($scope.refreshInterval) if $scope.refreshInterval
    if $state.current.name == "dashboard.deliver"
      $scope.refreshInterval = $interval ->
        refresh()
        if !$scope.$$phase
          $scope.$apply()
      , 10000
  $rootScope.$broadcast "$stateChangeSuccess"
  deliveryPlaceByPlaceID = (place_id) ->
    _.find $scope.deliveryPlaces, (dp) ->
      dp.place.id == place_id

  $scope.isLoading = true
  $scope.shift = null

  refresh = ->
    Shifts.get id: $scope.shiftID, (shift) ->
      $scope.setShift(shift)

  load = ->
    if $state.current.name == "dashboard.deliver.places"
      $scope.isLoading = false
    else
      Shifts.query (shifts) ->
        for shift in shifts
          shift = new Shifts(shift)
          if shift.isOngoing()
            $scope.setShift(shift)
            return null
        $scope.isLoading = false
        $state.go("dashboard.choose_seller")
  load()

  $scope.notify = (deliveryPlace) ->
    deliveryPlace.isNotifying = true
    Shifts.update id: $scope.shift.id,
      delivery_place_id: deliveryPlace.id
      delivery_place_state_id: 1
    , (shift) ->
      $scope.setShift(shift)
    , (error) ->
      deliveryPlace.isNotifying = false

  $scope.setShift = (shift) ->
    $scope.shiftID = shift.id
    $scope.deliveryPlaces = shift.deliveryPlaces()
    $scope.shift = shift
    $scope.isLoading = false
  $scope.endShift = ->
    $scope.isEndingShift = true
    Shifts.update id: $scope.shift.id,
      state_id: 2
    , (shift) ->
      $scope.success = true
      $interval.cancel($scope.reloadInterval)
      $timeout ->
        $scope.isEndingShift = false
        $state.go("dashboard.foods")
      , 250
    , (error) ->
      $scope.error = error.data.message


  $scope.callUser = (user) ->
    location.href = "tel://#{$scope.user.phone}"
  $scope.deliverOrder = (order) ->
    order.isDelivering = true
    dp = deliveryPlaceByPlaceID(order.place.id)
    index = dp.pendingOrders().indexOf(order)

    Orders.update id: order.id,
      state_id: 2
    , (order) ->
      dp.pendingOrders().splice(index, 1)
      if dp.pendingOrders().length == 0
        index = $scope.deliveryPlaces.indexOf(dp)
        $scope.deliveryPlaces.splice(index, 1)
    , (error) ->
      order.isDelivering = false

  $scope.reset = ->
    $scope.isEndingShift = false
    $scope.success = false
    $scope.error = false
    $scope.shiftID = null


  $scope.timingState = (dp) ->
    fromSeconds = null
    toSeconds = null

    index = $scope.deliveryPlaces.indexOf(dp)
    if index > 0 && index < $scope.deliveryPlaces.length - 1
      from = $scope.deliveryPlaces[index - 1].eta()
      to = dp.eta()
    else
      # 15 minutes from the DP's ETA
      from = new Date(dp.eta().getTime() - (900 * 1000))
      to = dp.eta()

    fromSeconds = Math.abs( ( new Date().getTime() - from.getTime() )  / 1000)

    # To is the time from when they were estimated to depart less than the time they're estimated to arrive
    toSeconds = Math.abs( ( to.getTime() - from.getTime() ) / 1000)

    if fromSeconds / toSeconds < 0.25
      return "all-good"
    else if fromSeconds / toSeconds < 0.75
      return "hurry-up-bro"
    else
      return "your-late-asshole"