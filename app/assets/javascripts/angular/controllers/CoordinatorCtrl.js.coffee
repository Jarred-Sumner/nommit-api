@nommit.controller "CoordinatorCtrl", ($state, Foods, Places, $scope, $rootScope, Users, Sessions, $cookies, $detection, $timeout) ->
  $scope.isInstalled = window.settings.isInstalled()
  if $scope.isInstalled && !window.settings.hasRequestedPushNotifications() && Sessions.isLoggedIn()
    $timeout ->
      $rootScope.requestPushNotifications = true
      window.settings.setRequestedPushNotifications()
    , 1000

  $rootScope.cancelPushNotifications = ->
    $rootScope.requestPushNotifications = false

  $rootScope.$on "$stateChangeSuccess", ->
    $scope.isDashboardVisible = false
    $scope.page = $state.current.name
    if $detection.isiOS() && $scope.page == "foods"
      $scope.isiOSBannerVisible = true
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
  $scope.isConfirmPhoneVisible = false
  $scope.isActivateVisible = false

  $rootScope.requireLogin = ->
    location.pathname = "/login" unless Sessions.isLoggedIn()
  $rootScope.requireActivation = ->
    $scope.isLoginVisible = false
    $scope.isConfirmPhoneVisible = false

    $scope.isActivateVisible = true
  $rootScope.requireConfirm = ->
    $scope.isLoginVisible = false
    $scope.isActivateVisible = false

    $scope.isConfirmPhoneVisible = true
  $scope.hideLogin = ->
    $scope.isLoginVisible = false
  $rootScope.hideConfirmPhone = ->
    $scope.isLoginVisible = false
    $scope.isConfirmPhoneVisible = false
    $scope.isActivateVisible = false

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

  $rootScope.hideDashboard = ->
    $scope.isDashboardVisible = false
  $scope.toggleDashboard = ->
    unless isDashboardDisabled()
      $scope.isDashboardVisible = !$scope.isDashboardVisible
      $rootScope.$broadcast "ToggledDashboard", $scope.isDashboardVisible
