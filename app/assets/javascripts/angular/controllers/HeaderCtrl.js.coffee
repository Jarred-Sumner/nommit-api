@nommit.controller 'HeaderCtrl', ($scope, Places, $rootScope, Facebook, Sessions) ->
  $scope.search =
    places: []
    query: ""

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
      $scope.places = _.sortBy $scope.places, (place) ->
        place.name

      $scope.search.places = $scope.places

      $rootScope.$broadcast("placeIDChanged", placeID: $scope.place.id)
    else
      $scope.setCurrentPlace($scope.places[0].id)
  $scope.filterPlaces = ->
    if $scope.search.query.length > 0
      $scope.search.places = _.filter $scope.search.places, (place) ->
        place.name.indexOf($scope.search.query) > -1
    else
      $scope.search.places = $scope.places

  $scope.closeOnEsc = ($event) ->
    if $event.keyCode == 27
      $scope.changingPlace = false

  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
    $scope.loggedIn = Sessions.isLoggedIn()
    $scope.isShowingLogin = false

  $rootScope.$on "$stateChangeSuccess", ->
    # Fetch current user
    # Notify all controllers that current user is available
    Sessions.currentUser() if Sessions.isLoggedIn()

  $scope.showLogin = ->
    $scope.isShowingLogin = true
  $scope.hideLogin = ->
    $scope.isShowingLogin = false
  $scope.showActivation = ->
    $scope.isShowingActivation = true
  $scope.showPlaces = ->
    $scope.changingPlace = true
  $scope.hidePlaces = ->
    $scope.changingPlace = false

  $rootScope.$on "requireLogin", ->
    $scope.showLogin() unless $scope.user?
  $rootScope.$on "requireActivation", ->
    $scope.showActivation() if $scope.user? && $scope.user.isRegistered()
  $rootScope.$on "requireValidation", ->
    $scope.isShowingConfirmPhone = true
  $rootScope.$on "confirmOrder", (event, food) ->
    $scope.isShowingConfirmOrder = true

  $rootScope.$on "HideActivation", (event, obj) ->
    $scope.isShowingActivation = false
    obj.callback() if obj.callback
  $rootScope.$on "HideConfirmPhone", (event, obj) ->
    $scope.isShowingConfirmPhone = false
    obj.callback() if obj.callback
