@nommit.controller "CoordinatorCtrl", ($state, Foods, Places, $scope, $rootScope, Users) ->
  $rootScope.$on "$stateChangeSuccess", ->
    $scope.isDashboardVisible = false
    $scope.page = $state.current.name
  $rootScope.$on "$stateChangeError", ->
    $scope.isDashboardVisible = false
  $rootScope.$on "$viewContentLoading", ->
    $scope.isDashboardVisible = false

  Users.get id: "me", (user) ->
    $scope.user = new Users(user)

  isDashboardDisabled = ->
    disabled = [
      "foods.places"
    ]
    disabled.indexOf($state.current.name) > -1
  $scope.isModalVisible = ->
    modals = [
      "foods.places"
    ]
    modals.indexOf($state.current.name) > -1

  $scope.toggleDashboard = ->
    $scope.isDashboardVisible = !$scope.isDashboardVisible unless isDashboardDisabled()
