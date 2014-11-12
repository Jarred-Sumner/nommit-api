@nommit.controller "CoordinatorCtrl", ($state, Foods, Places, $scope, $rootScope, Users, Sessions, $cookies) ->
  $rootScope.$on "$stateChangeSuccess", ->
    $scope.isDashboardVisible = false
    $scope.page = $state.current.name
  $rootScope.$on "$stateChangeError", ->
    $scope.isDashboardVisible = false
  $rootScope.$on "$viewContentLoading", ->
    $scope.isDashboardVisible = false

  $rootScope.$on "CurrentUser", (event, user) ->
    $rootScope.user = user

  # Check if we have a pending session cookie
  # Set that as the current user
  if $cookies.sessionID
    Sessions.setSessionID($cookies.sessionID)
    delete $cookies.sessionID
  else
    # Fetch the current user
    Sessions.currentUser()

  $scope.isLoginVisible = false

  $rootScope.requireLogin = (food, place) ->
    $scope.food_id = food.id
    $scope.place_id = place.id

    $scope.food_image = food.header_image_url
    $scope.isLoginVisible = true

  $scope.hideLogin = ->
    $scope.isLoginVisible = false

  isDashboardDisabled = ->
    disabled = [
      "foods.places"
    ]
    disabled.indexOf($state.current.name) > -1
  $scope.isModalVisible = ->
    modals = [
      "foods.places"
    ]
    modals.indexOf($state.current.name) > -1 || $scope.isLoginVisible

  $scope.toggleDashboard = ->
    $scope.isDashboardVisible = !$scope.isDashboardVisible unless isDashboardDisabled()
