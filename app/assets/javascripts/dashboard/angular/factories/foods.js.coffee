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
    this.order_count == 0
  Foods::isOrderable = ->
    this.isActive() && this.isOngoing() && !this.isSoldOut()
  Foods::remaining = ->
    @goal - @order_count
  Foods::progress = ->
    ( (@goal - @order_count) / @goal) * 100.0
  Foods::pricingByID = (id) ->
    _.find @prices, (price) ->
      price.id == id
  Foods::priceByID = (id) ->
    this.pricingByID(id).price
  Foods::quantityByID = (id) ->
    this.pricingByID(id).quantity

  Foods
]
