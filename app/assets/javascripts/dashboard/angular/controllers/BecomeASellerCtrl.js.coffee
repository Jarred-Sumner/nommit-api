@nommit.controller "BecomeASellerCtrl", ($http, $scope) ->
  $scope.apply = ->
    $scope.isApplying = true
    $http.post("api/v1/sellers")
      .success ->
        $scope.success = true
      .error (error) ->
        $scope.error = error.data.message
  $scope.reset = ->
    $scope.isApplying = false
    $scope.error = null
    $scope.success = null