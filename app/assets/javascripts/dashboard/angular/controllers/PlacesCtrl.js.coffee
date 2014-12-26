@nommit.controller "PlacesCtrl", ($state, Foods, Places, $scope, $stateParams) ->
  $scope.query = ""
  $scope.searchPlaces = ->
    if $scope.query.length > 0
      normalized = _.str.titleize($scope.query)
      $scope.places = _.select $scope.allPlaces, (place) ->
        _.str.titleize(place.name).indexOf(normalized) > -1
    else
      $scope.places = $scope.allPlaces

  fetchPlaces = ->
    Places.query (places) ->
      $scope.allPlaces = _.select places, (place) ->
        place.food_count > 0
      $scope.places = $scope.allPlaces

  $scope.setPlaceID = (placeID) ->
    if $stateParams.food_id
      $state.go "dashboard.foods.order", { place_id: placeID, food_id: $stateParams.food_id }
    else
      $state.go "dashboard.foods", { place_id: placeID }
  fetchPlaces()
