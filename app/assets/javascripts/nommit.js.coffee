window.settings =
  placeID: ->
    @id ||= localStorage["placeID"]
  setPlaceID: (id) ->
    localStorage['placeID'] = id
    @id = id

@nommit = angular.module('nommit', ['ui.router', 'ngResource'])

# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
@nommit.config ($stateProvider, $urlRouterProvider, $httpProvider) ->

  $urlRouterProvider.otherwise("/")

  $stateProvider
    .state('foods',
      url: "/"
      templateUrl: 'dashboard/partials/foods'
      controller: 'FoodsCtrl'
    )
