@nommit.factory 'Schools', ($resource) ->
  Schools = $resource 'api/v1/schools/:id', id: '@id'
  Schools::from = ->
    @_from ||= new Date(@from_hours) if @from_hours
  Schools::to = ->
    @_to ||= new Date(@to_hours) if @to_hours

  Schools::motdExpiration = ->
    @_motdExpiration ||= new Date(@motd_expiration)

  Schools::isMOTDExpired = ->
    this.motdExpiration() < new Date()
  Schools::showMOTD = ->
    !!@motd && !this.isMOTDExpired()
  Schools::hasHours = ->
    this.from() && this.to()
  Schools::showHours = ->
    !@motd && this.hasHours()
  Schools::showSpecialEvents = ->
    !@motd && !this.hasHours()
  Schools

