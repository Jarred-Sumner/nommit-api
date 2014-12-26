@nommit.controller "SupportCtrl", ($scope) ->
  $scope.phone = "14152739617"
  $scope.call = ->
    location.href = "tel://#{$scope.phone}"
    $scope.calling = true
    $scope.popup = true
  $scope.text = ->
    location.href = "sms://#{$scope.phone}"
    $scope.smsPopup = true
    $scope.texting = true
    $scope.popup = true
  $scope.email = ->
    location.href = "mailto:support@getnommit.com"
    $scope.emailing = true
    $scope.popup = true

  $scope.reset = ->
    $scope.popup = false
    $scope.emailing = false
    $scope.calling = false
    $scope.texting = false
