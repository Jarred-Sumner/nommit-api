@nommit.factory 'Sessions', ['$resource', 'Users', '$http', '$rootScope', ($resource, Users, $http, $rootScope) ->
  Sessions = $resource "api/v1/sessions"

  angular.extend Sessions,
    login: (user, cb) ->
      Sessions.save access_token: user.accessToken, (user, headers) ->
        sessionID = headers()["x-session-id"]
        $http.defaults.headers.common["X-SESSION-ID"] = sessionID
        window.settings.setSessionID(sessionID)

        Sessions.setCurrentUser(new Users(user))
        cb(new Users(user))
    setCurrentUser: (user) ->
      $rootScope.$broadcast("CurrentUser", user)
      window.settings.setUserID(user.id)
      @user = user
    currentUser: ->
      @user ||= Users.get("me") if Sessions.isLoggedIn()
    isLoggedIn: ->
      window.settings.sessionID() && window.settings.sessionID().length > 0

  Sessions
]
