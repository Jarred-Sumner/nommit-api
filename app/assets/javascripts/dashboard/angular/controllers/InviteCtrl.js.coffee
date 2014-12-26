@nommit.controller "InviteCtrl", ($scope) ->
  $scope.inviteFriends = ->
    if window.Android && window.Android.openContacts
      window.Android.openContacts(window.settings.sessionID())

  $scope.shareOnFacebook = ->
    window.Android.shareOnFacebook($scope.user.referral_code)
  $scope.shareOnTwitter = ->
    window.Android.shareOnTwitter($scope.user.referral_code)
  $scope.shareOnMessenger = ->
    window.Android.shareOnMessenger($scope.user.referral_code)
