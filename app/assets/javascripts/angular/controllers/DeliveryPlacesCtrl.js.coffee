@nommit.controller "DeliveryPlacesCtrl", ($scope, Places, $state, Couriers, Shifts, $timeout) ->
  refresh = ->
    Couriers.me (couriers) ->
      active = couriers[0]

      Places.query courier_id: active.id, (places) ->
        $scope.places = places
        $scope.visiblePlaces = places
        $scope.selectedPlaces = []

        if $scope.shift
          for dp in $scope.shift.deliveryPlaces()
            $scope.selectedPlaces.push(dp.place.id)
  $scope.searchPlaces = (query) ->
    if $scope.query.length > 0
      normalized = _.str.titleize($scope.query)
      $scope.visiblePlaces = _.select $scope.places, (place) ->
        _.str.titleize(place.name).indexOf(normalized) > -1
    else
      $scope.visiblePlaces = $scope.places
  $scope.togglePlace = (placeID) ->
    index = $scope.selectedPlaces.indexOf(placeID)
    if index == -1
      $scope.selectedPlaces.push(placeID)
    else
      $scope.selectedPlaces.splice(index, 1)

  $scope.updateShift = ->
    $scope.isUpdating = true
    updatedShift = (shift) ->
      $scope.shift = new Shifts(shift)
      $scope.success = true
      $timeout ->
        $scope.isUpdating = false
        $state.go("deliver")
      , 150

    errorWhileUpdating = (error) ->
      $scope.error = error.data.message

    if $scope.shift
      Shifts.update(id: $scope.shift.id,
        place_ids: $scope.selectedPlaces,
        updatedShift,
        errorWhileUpdating
      )
    else
      Shifts.save(place_ids: $scope.selectedPlaces, updatedShift, errorWhileUpdating)




  $scope.reset = ->
    $scope.query = null
    $scope.selectedPlaces = []
    $scope.places = null
    $scope.visiblePlaces = null
    $scope.isUpdating = false
    $scope.error = null
    $scope.success = false
    refresh()
  $scope.reset()
