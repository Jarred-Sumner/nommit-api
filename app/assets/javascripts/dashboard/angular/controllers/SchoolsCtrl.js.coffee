@nommit.controller "SchoolsCtrl", ($scope, Users, Sessions, $rootScope, $timeout, $state, Schools) ->
  $scope.searchSchools = ->
    if $scope.query.length > 0
      normalized = _.str.titleize($scope.query)
      $scope.schools = _.select $scope.allSchools, (school) ->
        _.str.titleize(school.name).indexOf(normalized) > -1
    else
      $scope.schools = $scope.allSchools

  fetchSchools = ->
    Schools.query (schools) ->
      $scope.allSchools = schools
      $scope.schools = $scope.allSchools
  fetchSchools()
  $scope.setSchoolID = (id) ->
    $scope.isSaving = true
    Users.update id: $scope.user.id,
      school_id: id
    , (user) ->
      Sessions.setCurrentUser(user)
      $scope.didSave = true
      $timeout ->
        $scope.isSaving = false
        $scope.didSetSchool()
      , 750
    , (error) ->
      $scope.error = error.data.message

  $scope.reset = ->
    $scope.query = null
    $scope.isSaving = false
    $scope.didSave = false
    $scope.error = null
  $scope.reset()
