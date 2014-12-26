@nommit.controller "HeaderCtrl", ($state, Sessions, $rootScope, $scope) ->
  $scope.navigate = (name, params) ->
    $rootScope.hideDashboard()
    $state.go("dashboard.#{name}", params)
