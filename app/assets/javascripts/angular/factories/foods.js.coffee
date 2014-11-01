@nommit.factory 'Foods', ['$resource', ($resource) ->
  Foods = $resource 'api/v1/foods/:id', id: '@id'

  Foods::price = ->
    @prices[@quantity - 1].price
  Foods::isActive = ->
    @state_id == 0
  Foods::startDate = ->
    new Date(@start_date)
  Foods::endDate = ->
    new Date(@end_date)
  Foods::isOngoing = ->
    new Date() > this.startDate() && new Date() < this.endDate()
  Foods::isOrderable = ->
    this.isActive() && this.isOngoing()

  Foods
]
