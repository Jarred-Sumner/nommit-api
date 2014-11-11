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
    @_placeID
  setPlaceID: (id) ->
    @_placeID = id
  didRedirectOniOS: ->
    localStorage["didRedirectOniOS"]
  setDidRedirectOniOS: ->
    localStorage["didRedirectOniOS"] = true
  didRedirectOnAndroid: ->
    localStorage["didRedirectOnAndroid"]
  setDidRedirectOnAndroid: ->
    localStorage["didRedirectOnAndroid"] = true

@nommit = angular.module('nommit', ['ui.router', 'ngResource', 'facebook', 'angularPayments', 'angular-spinkit', 'timer', 'ngCacheBuster', 'adaptive.detection', 'ngAnimate', 'ngTouch'])

# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
@nommit.config ($stateProvider, $urlRouterProvider, $httpProvider, FacebookProvider, $locationProvider, $compileProvider, httpRequestInterceptorCacheBusterProvider) ->
  $locationProvider.html5Mode(true);

  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|http|sms|tel):/)
  FacebookProvider.init(window.config.facebook);

  $urlRouterProvider.otherwise("/")
  $stateProvider
    .state 'foods',
      url: "/?place_id"
      templateUrl: "/dashboard/partials/foods"
    .state "foods.places",
      url: "/places"
      templateUrl: "/dashboard/partials/places"
    .state "order",
      url: "/order?food_id&place_id"
      templateUrl: "/dashboard/partials/orders/new"
    .state "deliver",
      url: "/deliver"
      templateUrl: "/dashboard/partials/deliver"
    .state "account",
      url: "/account"
      templateUrl: "/dashboard/partials/account"
    .state "invite",
      url: "/invite"
      templateUrl: "/dashboard/partials/invite"
    .state "support",
      url: "/support"
      templateUrl: "/dashboard/partials/support"
    .state "fundraise",
      url: "/fundraise"
      templateUrl: "/dashboard/partials/fundraise"
    .state "orders",
      url: "/orders/:id"
      tmeplateUrl: "/dashboard/partials/orders/show"


  $httpProvider.defaults.headers.common["X-APP-VERSION"] = "MASTER"

  if navigator.userAgent.toLowerCase().indexOf("android") > -1
    $httpProvider.defaults.headers.common["X-APP-PLATFORM"] = "Android"
  else
    $httpProvider.defaults.headers.common["X-APP-PLATFORM"] = "Website"

  $httpProvider.defaults.headers.common["X-SESSION-ID"] = window.settings.sessionID()
  httpRequestInterceptorCacheBusterProvider.setMatchlist [/users/, /partials/], true
