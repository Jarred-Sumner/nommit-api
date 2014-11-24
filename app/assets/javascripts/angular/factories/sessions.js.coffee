@nommit.factory 'Sessions', ($resource, Users, $http, $rootScope) ->
  Sessions = $resource "api/v1/sessions"

  angular.extend Sessions,
    setSessionID: (id) ->
      $http.defaults.headers.common["X-SESSION-ID"] = id
      window.settings.setSessionID(id)
      Sessions.currentUser()
    setCurrentUser: (user) ->
      user = new Users(user)
      $rootScope.$broadcast("CurrentUser", user)
      window.settings.setUserID(user.id)
      @user = user
    currentUser: (cb) ->
      if Sessions.isLoggedIn()
        if @user
          $rootScope.$broadcast("CurrentUser", @user)
          return cb(@user) if cb
        else
          Users.get id: "me", (user) ->
            Sessions.setCurrentUser(user)
            cb(user) if cb
      else
        cb(null) if cb
    isLoggedIn: ->
      window.settings.sessionID() && window.settings.sessionID().length > 0

  Sessions
