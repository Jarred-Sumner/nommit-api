@nommit.controller "LoginCtrl", ($scope, $rootScope, $location) ->
  $scope.login = (food_id, place_id) ->
    if food_id && place_id
      @path = escape("/foods/#{food_id}/order?place_id=#{place_id}")
    else
      @path = escape(location.pathname)
    location.href = "/auth/facebook?path=#{@path}"
