@nommit.factory 'Sessions', ['$resource', 'Users', '$http', '$rootScope', ($resource, Users, $http, $rootScope) ->
  Sessions = $resource "api/v1/sessions"

  angular.extend Sessions,
    login: (user, cb) ->
      Sessions.save access_token: user.accessToken, (user, headers) ->
        user = new Users(user)
        sessionID = headers()["x-session-id"]
        $http.defaults.headers.common["X-SESSION-ID"] = sessionID
        window.settings.setSessionID(sessionID)

        Sessions.setCurrentUser(user)
        cb(user)
    setCurrentUser: (user) ->
      $rootScope.$broadcast("CurrentUser", user)
      window.settings.setUserID(user.id)
      @user = user
    currentUser: (cb) ->
      if Sessions.isLoggedIn()
        unless @user
          @user = Users.get id: "me", (user) ->
            console.log(user)
            $rootScope.$broadcast("CurrentUser", user)
            cb(user) if cb
      else
        cb(null) if cb
    isLoggedIn: ->
      window.settings.sessionID() && window.settings.sessionID().length > 0

  Sessions
]
