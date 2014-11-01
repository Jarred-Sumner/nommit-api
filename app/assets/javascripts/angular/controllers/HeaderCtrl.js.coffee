@nommit.controller 'HeaderCtrl', ($scope, Places, $rootScope, Facebook, Sessions, Orders, $stateParams, $detection, Foods) ->

  checkForOrdersThatNeedToBeRated = ->
    Orders.query state_id: 2,  (orders) ->
      if orders.length > 0
        order = orders[0]
        $rootScope.$emit "RateFood", order: order
        $scope.isRatingFood = true

  $scope.search =
    places: []
    query: ""

  Places.query (places) ->
    $scope.places = _.select places, (place) ->
      for dp in place.delivery_places
        for food in dp.foods
          food = new Foods(food)
          return true if food.isOrderable()
      false
    setCurrentPlace(window.settings.placeID())

  $scope.toggleMobileNav = ->
    $scope.mobileNavVisible = !$scope.mobileNavVisible

  $scope.setCurrentPlace = (placeID) ->
    setCurrentPlace(placeID)
    $scope.changingPlace = false
  setCurrentPlace = (id) ->

    if id
      old_place = $scope.place
      $scope.place = _.find $scope.places, (place) ->
        String(id) == String(place.id)
      if $scope.place
        $scope.places.push(old_place) if old_place

        # Remove current place from array
        $scope.places = _.without($scope.places, $scope.place)
        $scope.search.places = $scope.places
        $rootScope.$broadcast("placeChanged", place: $scope.place)
    else
      $scope.showPlaces() if $scope.places && $scope.places.length > 0
  $scope.filterPlaces = ->
    if $scope.search.query.length > 0
      query = _.str.titleize($scope.search.query)
      $scope.search.places = _.filter $scope.search.places, (place) ->
        name = _.str.titleize(place.name)
        _.str.include(name, query)
    else
      $scope.search.places = $scope.places

    $scope.search.places = _.sortBy $scope.search.places, (place) ->
      place.name

  $scope.closeOnEsc = ($event) ->
    if $event.keyCode == 27
      $scope.changingPlace = false

  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user
    $scope.loggedIn = Sessions.isLoggedIn()

  $rootScope.$on "$stateChangeSuccess", (event, state) ->
    $scope.hideMobileNav()
    $scope.page = state.name
    # Fetch current user
    # Notify all controllers that current user is available
    Sessions.currentUser() if Sessions.isLoggedIn()

  $scope.hideMobileNav = (manual) ->
    $scope.mobileNavVisible = false

  $scope.showLogin = ->
    $scope.isShowingLogin = true
    $scope.hideMobileNav()
  $scope.hideLogin = ->
    $scope.isShowingLogin = false
  $scope.showActivation = ->
    $scope.isShowingActivation = true
  $scope.showPlaces = ->
    $scope.filterPlaces()
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
  $rootScope.$on "confirmOrder", ->
    $scope.isShowingConfirmOrder = true


  $rootScope.$on "HideLogin", (event, data) ->
    $scope.isShowingLogin = false
    if data && data.callback
      obj = data.callback
      obj.callback(obj.object) if obj.callback
  $rootScope.$on "HideActivation", (event, obj) ->
    $scope.isShowingActivation = false
    obj.callback() if obj
  $rootScope.$on "HideConfirmPhone", (event, data) ->
    $scope.isShowingConfirmPhone = false
    obj = data.callback if data
    obj.callback(obj.object) if obj
  $rootScope.$on "HideRateFood", ->
    $scope.isRatingFood = false


  params = ->
    qs = ((a) ->
      return {}  if a is ""
      b = {}
      i = 0

      while i < a.length
        p = a[i].split("=", 2)
        if p.length is 1
          b[p[0]] = ""
        else
          b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "))
        ++i
      b
    )(window.location.search.substr(1).split("&"))
  postInit = ->
    checkForOrdersThatNeedToBeRated()

    window.settings.setDidRedirectOnAndroid() if params()["android"] == "true"

    if $detection.isiOS() && !window.settings.didRedirectOniOS()
      window.settings.setDidRedirectOniOS()
      location.href = window.config.iTunesURL
    if $detection.isAndroid() && !window.settings.didRedirectOnAndroid()
      window.settings.setDidRedirectOnAndroid()
      location.href = window.config.PlayStoreURL

  postInit()
