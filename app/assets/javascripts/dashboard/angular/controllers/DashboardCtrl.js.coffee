@nommit.controller "DashboardCtrl", ($state, Foods, Places, $scope, $rootScope, Users, Sessions, $cookies, $detection, $timeout) ->
  $scope.isDesktop = !($detection.isAndroid() || $detection.isiOS() || $detection.isWindowsPhone() || $detection.isBB10())
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
    $rootScope.page = $state.current.name
    if $detection.isiOS() && $rootScope.page == "dashboard.foods"
      $scope.isiOSBannerVisible = true
    $rootScope.requireLogin()
    $rootScope.requireActivation()
    $rootScope.isLoadingFirstState = false
    $rootScope.didLoadFirstState = true
  $rootScope.$on "$stateChangeError", ->
    $scope.isDashboardVisible = false
    $rootScope.isLoadingFirstState = false
  $rootScope.$on "$stateChangeStart", ->
    $rootScope.isLoadingFirstState = true
  $rootScope.$on "$viewContentLoading", ->
    $scope.isDashboardVisible = false
  $rootScope.requireLogin = ->
    location.pathname = "/login" unless Sessions.isLoggedIn()
  $rootScope.requireActivation = ->
    return false if $state.current.name.indexOf("activate") > -1
    location.pathname = "/activate" unless $scope.user.isActivated()
  isDashboardDisabled = ->
    disabled = [
      "dashboard.foods.places"
    ]
    disabled.indexOf($state.current.name) > -1
  $scope.isModalVisible = ->
    modals = [
      "dashboard.foods.places"
    ]
    modals.indexOf($state.current.name) > -1 || $scope.isLoginVisible

  $rootScope.hideDashboard = ->
    $scope.isDashboardVisible = false
  $rootScope.toggleDashboard = ->
    unless isDashboardDisabled()
      $scope.isDashboardVisible = !$scope.isDashboardVisible
      $rootScope.$broadcast "ToggledDashboard", $scope.isDashboardVisible
