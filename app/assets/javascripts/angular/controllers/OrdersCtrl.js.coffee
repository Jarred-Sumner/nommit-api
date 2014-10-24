@nommit.controller 'OrdersCtrl', ($scope, Foods, Places, $rootScope, Orders, Sessions) ->
  $rootScope.$emit("requireLogin") unless Sessions.isLoggedIn()

  $rootScope.$on "CurrentUser", ->
    $scope.orders = Orders.query ->
      window.orders = $scope.orders
