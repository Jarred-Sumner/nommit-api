@nommit.controller "PlacesCtrl", ($state, Foods, Places, $scope) ->
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
  fetchPlaces()
