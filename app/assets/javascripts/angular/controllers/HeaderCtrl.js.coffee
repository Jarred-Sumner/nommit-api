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

      $scope.setCurrentPlace($scope.places[0].id) unless $scope.place

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
      query = _.str.titleize($scope.search.query)
      $scope.search.places = _.filter $scope.search.places, (place) ->
        name = _.str.titleize(place.name)
        _.str.include(name, query)
    else
      $scope.search.places = $scope.places

  $scope.closeOnEsc = ($event) ->
    if $event.keyCode == 27
      $scope.changingPlace = false

  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
    $scope.loggedIn = Sessions.isLoggedIn()

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

  $rootScope.$on "requireLogin", (event, obj) ->
    $scope.showLogin() unless $scope.user?
  $rootScope.$on "requireActivation", (event, obj) ->
    $scope.isShowingLogin = false
    if $scope.user? && $scope.user.isRegistered()
      $scope.showActivation()


  $rootScope.$on "requireValidation", ->
    $scope.isShowingConfirmPhone = true
  $rootScope.$on "confirmOrder", (event, food) ->
    $scope.isShowingConfirmOrder = true

  $rootScope.$on "HideLogin", (event, obj) ->
    $scope.isShowingLogin = false
    obj.callback(obj.object) if obj.callback
  $rootScope.$on "HideActivation", (event, obj) ->
    $scope.isShowingActivation = false
    obj.callback(obj.object) if obj
  $rootScope.$on "HideConfirmPhone", (event, obj) ->
    $scope.isShowingConfirmPhone = false
    console.log(obj)
    obj.callback(obj.object) if obj
