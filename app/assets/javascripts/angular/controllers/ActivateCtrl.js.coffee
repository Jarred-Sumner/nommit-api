@nommit.controller 'ActivateCtrl', ($scope, Sessions, Places, $rootScope) ->
  $scope.close = ->
    $rootScope.$emit("HideActivation")
  $rootScope.$on "CurrentUser", (event, user) ->
    $scope.user = user

  $scope.activation =
    card: null
    expiry: null
    cvc: null
    phone: null

  $scope.activate = (status, response) ->
    $scope.isActivating = false
