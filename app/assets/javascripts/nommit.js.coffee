window.settings =
  setSessionID: (id) ->
    localStorage["sessionID"] = id
  sessionID: ->
    localStorage['sessionID']
  setUserID: (userID) ->
    localStorage["userID"] = userID
  userID: ->
    localStorage["userID"]
  placeID: ->
    localStorage["placeID"]
  setPlaceID: (id) ->
    localStorage['placeID'] = id

@nommit = angular.module('nommit', ['ui.router', 'ngResource', 'facebook', 'angularPayments', 'angular-spinkit', 'timer'])

# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
@nommit.config ($stateProvider, $urlRouterProvider, $httpProvider, FacebookProvider, $locationProvider, $compileProvider) ->
  $locationProvider.html5Mode(true);
  $urlRouterProvider.otherwise("/")

  $stateProvider
    .state('foods',
      url: "/"
      templateUrl: 'dashboard/partials/foods'
      controller: 'FoodsCtrl'
    ).state('orders',
      url: '/orders'
      templateUrl: 'dashboard/partials/orders'
      controller: 'OrdersCtrl'
    ).state("account",
      url: "/account"
      templateUrl: 'dashboard/partials/account'
      controller: "AccountCtrl"
    )

  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|http|sms|tel):/)
  FacebookProvider.init(window.config.facebook);
  $httpProvider.defaults.headers.common["X-SESSION-ID"] = window.settings.sessionID()
