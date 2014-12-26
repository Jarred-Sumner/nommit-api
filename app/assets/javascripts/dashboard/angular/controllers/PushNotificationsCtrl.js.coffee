@nommit.controller "PushNotificationsCtrl", ($scope, $rootScope) ->
  $scope.notifyMe = ->
    if window.Android && window.Android.requestPushNotificationAcccess
      window.Android.requestPushNotificationAccess(window.settings.sessionID(), window.settings.userID())
    $rootScope.cancelPushNotifications()
