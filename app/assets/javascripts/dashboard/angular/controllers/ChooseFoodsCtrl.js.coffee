@nommit.controller "ChooseFoodsCtrl", ($state, Foods, Places, $stateParams, DeliveryPlaces, $scope, $timeout, $rootScope, Users, $detection) ->
  $scope.seller_id = $stateParams.seller_id
  $scope.isLoading = true
  Foods.query seller_id: $stateParams.seller_id, (foods) ->
    $scope.isLoading = false
    $scope.foods = foods
    $scope.selectedFoods = []
  $scope.toggleFood = (id) ->
    if $scope.selectedFoods.indexOf(id) > -1
      $scope.selectedFoods.splice($scope.selectedFoods.indexOf(id), 1)
    else
      $scope.selectedFoods.push(id)