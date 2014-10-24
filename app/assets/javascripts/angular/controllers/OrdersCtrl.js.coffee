@nommit.controller 'OrdersCtrl', ($scope, Foods, Places, $rootScope, Orders) ->
  $scope.orders = Orders.query()
