@nommit.controller 'HeaderCtrl', ($scope, Places, $rootScope, Facebook, Sessions) ->
  $scope.loggedIn = Sessions.isLoggedIn()
  $scope.places = Places.query (places) ->
    setCurrentPlace(window.settings.placeID())
  $scope.setCurrentPlace = (placeID) ->
    window.settings.setPlaceID(placeID)
    setCurrentPlace(placeID)
    $scope.changingPlace = false
  setCurrentPlace = (id) ->
    if id
      $scope.places.push($scope.place) if $scope.place?
      $scope.place = _.find $scope.places, (place) ->
        String(place.id) == String(id)

      # Remove current place from array and alphabetize places
      $scope.places = _.without($scope.places, $scope.place)
      $scope.places = _.sortBy($scope.places, (place) ->
        place.name
      )

      $rootScope.$broadcast("placeIDChanged", placeID: $scope.place.id)
    else
      $scope.setCurrentPlace($scope.places[0].id)
  $scope.stopChangingPlace = ->
    $scope.changingPlace = false

  $rootScope.$on "CurrentUser", (user) ->
    $scope.loggedIn = Sessions.isLoggedIn()

  $scope.showLogin = ->
    $scope.isShowingLogin = true
  # $scope.hideLogin = ->
  #   $scope.isShowingLogin = false
