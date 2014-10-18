# Taken from https://github.com/song-rate-mvc/angular-song-rate/blob/0.0.1

"use strict"

@nommit.directive "rating", ->
  directive = {}
  directive.restrict = "AE"
  directive.scope =
    score: "=score"
    max: "=max"
    readonly: "=readonly"

  directive.templateUrl = "/directives/stars.html"
  directive.link = (scope, elements, attr) ->
    $(elements).addClass("readonly") if scope.readonly
    scope.updateStars = ->
      idx = 0
      scope.stars = []
      idx = 0
      while idx < scope.max
        scope.stars.push full: scope.score > idx
        idx += 1

    scope.hover = (idx) ->
      scope.hoverIdx = idx unless scope.readonly

    scope.stopHover = ->
      scope.hoverIdx = -1 unless scope.readonly

    scope.starColor = (idx) ->
      starClass = "rating-normal"
      starClass = "rating-highlight"  if idx <= scope.hoverIdx
      starClass

    scope.starClass = (star, idx) ->
      starClass = "fa-star-o"
      starClass = "fa-star"  if star.full or idx <= scope.hoverIdx
      starClass

    scope.setRating = (idx) ->
      unless scope.readonly
        scope.score = idx + 1
        scope.stopHover()

    scope.$watch "score", (newValue, oldValue) ->
      scope.updateStars()  if newValue isnt null and newValue isnt `undefined`


  directive
