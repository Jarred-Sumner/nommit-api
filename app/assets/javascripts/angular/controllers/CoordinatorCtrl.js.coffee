@nommit.controller "CoordinatorCtrl", ($state, Foods, Places, $scope, $rootScope) ->
  $rootScope.$on "$stateChangeSuccess", ->
    $scope.isDashboardVisible = false
  $rootScope.$on "$stateChangeError", ->
    $scope.isDashboardVisible = false
  $rootScope.$on "$viewContentLoading", ->
    $scope.isDashboardVisible = false

  $scope.toggleDashboard = ->
    $scope.isDashboardVisible = !$scope.isDashboardVisible
