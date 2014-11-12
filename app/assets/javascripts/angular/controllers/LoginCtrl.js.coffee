@nommit.controller "LoginCtrl", ($scope, $rootScope, $location) ->
  $scope.login = (food_id, place_id) ->
    # TODO: Call Android bridge'd function for using Android FB SDK Login here
    location.href = "/auth/facebook?place_id=#{place_id}&food_id=#{food_id}"
