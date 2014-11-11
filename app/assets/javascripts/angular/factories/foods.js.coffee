@nommit.factory 'Foods', ['$resource', ($resource) ->
  Foods = $resource 'api/v1/foods/:id', id: '@id'

  Foods::price = ->
    @prices[@quantity - 1].price
  Foods::isActive = ->
    @state_id == 0
  Foods::startDate = ->
    @_startDate ||= new Date(@start_date)
  Foods::endDate = ->
    @_endDate ||= new Date(@end_date)
  Foods::isOngoing = ->
    !this.isPending() && !this.isExpired()
  Foods::isPending = ->
    this.startDate() > new Date()
  Foods::isExpired = ->
    new Date() > this.endDate()
  Foods::isSaleOver = ->
    !this.isActive()
  Foods::isSoldOut = ->
    this.remaining() < 0
  Foods::isOrderable = ->
    this.isActive() && this.isOngoing() && !this.isSoldOut()
  Foods::remaining = ->
    this.order_count
  Foods::progress = ->
    (this.order_count / this.goal) * 100.0

  Foods
]
