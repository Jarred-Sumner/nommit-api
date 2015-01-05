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
  setIsInstalled: ->
    localStorage.setItem("isInstalled", true)
  isInstalled: ->
    localStorage["isInstalled"] == "true"
  hasRequestedPushNotifications: ->
    localStorage["didRequestPushNotifications"] == "true"
  setRequestedPushNotifications: ->
    localStorage.setItem("didRequestPushNotifications", true)

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
    .state "dashboard",
      url: ""
      templateUrl: "/dashboard/partials/dashboard"
      resolve:
        user: (Users, Sessions, $cookies) ->
          Users.get(id: "me").$promise
        controller: (user, Sessions) ->
          Sessions.setCurrentUser(user)
    .state 'dashboard.foods',
      url: "/foods?place_id"
      templateUrl: "/dashboard/partials/foods"
    .state "dashboard.foods.places",
      url: "/places?food_id"
      templateUrl: "/dashboard/partials/places"
    .state "dashboard.foods.order",
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
    .state "dashboard.deliver",
      url: "/deliver"
      templateUrl: "/dashboard/partials/deliver"
    .state "dashboard.deliver.places",
      url: "/places"
      templateUrl: "/dashboard/partials/delivery_places"
    .state "dashboard.activate",
      url: "/activate"
      templateUrl: "/dashboard/partials/activate"
    .state "dashboard.activate.confirm",
      url: "/confirm"
      templateUrl: "/dashboard/partials/confirm"
    .state "dashboard.activate.payment_method",
      url: "/payment_method"
      templateUrl: "/dashboard/partials/payment_method"
    .state "dashboard.activate.schools",
      url: "/schools"
      templateUrl: "/dashboard/partials/schools"
    .state "dashboard.account",
      url: "/account"
      templateUrl: "/dashboard/partials/account"
    .state "dashboard.account.payment_method",
      url: "/payment_method"
      templateUrl: "/dashboard/partials/payment_method"
    .state "dashboard.account.schools",
      url: "/schools"
      templateUrl: "/dashboard/partials/schools"
    .state "dashboard.invite",
      url: "/invite"
      templateUrl: "/dashboard/partials/invite"
    .state "dashboard.support",
      url: "/support"
      templateUrl: "/dashboard/partials/support"
    .state "dashboard.sell",
      url: "/sell"
      templateUrl: "/dashboard/partials/sell"
    .state "dashboard.orders",
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

  $httpProvider.interceptors.push ($q) ->

    'responseError': (rejection) ->
        if rejection.status == 401
          location.replace("/login?path=#{location.pathname}")
        $q.reject(rejection)

@nommit.run ($cookies, $http, Sessions) ->
  if $cookies.sessionID
    Sessions.setSessionID($cookies.sessionID)
