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

@nommit = angular.module('nommit', ['ui.router', 'ngResource', 'angularPayments', 'angular-spinkit', 'timer', 'ngCacheBuster', 'adaptive.detection', 'ngAnimate', 'ngTouch', 'ngCookies'])

# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
@nommit.config ($stateProvider, $urlRouterProvider, $httpProvider, $locationProvider, $compileProvider, httpRequestInterceptorCacheBusterProvider) ->
  $locationProvider.html5Mode(true);

  $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|http|sms|tel):/)

  $urlRouterProvider.otherwise("/foods")
  $stateProvider
    .state 'foods',
      url: "/foods?place_id"
      templateUrl: "/dashboard/partials/foods"
    .state "foods.places",
      url: "/places"
      templateUrl: "/dashboard/partials/places"
    .state "foods.order",
      url: "/:food_id/order"
      templateUrl: "/dashboard/partials/orders/new"
      resolve:
        food: (Foods, $stateParams, $q, $timeout, $rootScope) ->
          if $rootScope.food && $rootScope.food.id == $stateParams.food_id
            deferred = $q.defer()
            $timeout ->
              deferred.resolve($rootScope.food)
            , 1
            deferred.promise
          else
            Foods.get(id: $stateParams.food_id).$promise
        place: ($rootScope, Places, $stateParams, $q, $timeout) ->
          if $rootScope.place && $rootScope.place_id == $stateParams.place_id
            deferred = $q.defer()
            $timeout ->
              deferred.resolve($rootScope.place)
            , 1
            deferred.promise
          else
            Places.get(id: $stateParams.place_id).$promise
      controller: ($scope, food, place, $rootScope) ->
        $scope.food = food
        $scope.place = place

        # Remove globals, because globals can cause unexpected issues
        delete $rootScope.food
        delete $rootScope.place

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
      url: "/orders/:order_id"
      templateUrl: "/dashboard/partials/orders/show"
      resolve:
        order: (Orders, $stateParams, $q, $timeout, $rootScope) ->
          if $rootScope.order && $rootScope.order.id == $stateParams.order_id
            deferred = $q.defer()
            $timeout ->
              deferred.resolve($rootScope.order)
            , 1
            deferred.promise
          else
            Orders.get(id: $stateParams.order_id).$promise
      controller: (order, $scope, $rootScope, Orders) ->
        $rootScope.order = order


  $httpProvider.defaults.headers.common["X-APP-VERSION"] = "MASTER"

  if navigator.userAgent.toLowerCase().indexOf("android") > -1
    $httpProvider.defaults.headers.common["X-APP-PLATFORM"] = "Android"
  else
    $httpProvider.defaults.headers.common["X-APP-PLATFORM"] = "Website"

  $httpProvider.defaults.headers.common["X-SESSION-ID"] = window.settings.sessionID()
  httpRequestInterceptorCacheBusterProvider.setMatchlist [/users/, /partials/], true
