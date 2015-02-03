@nommit.controller "ChooseSellerCtrl", ($state, Foods, Places, $stateParams, DeliveryPlaces, $scope, $timeout, $rootScope, Users, $detection, Sellers) ->
  $scope.isLoading = true
  Sellers.query (sellers) ->
    $scope.isLoading = false
    $scope.sellers = sellers