@nommit.controller "ActivateCtrl", ($scope, Users, Sessions, $rootScope, $timeout, $state) ->
  # Flow goes:
  # 1) Pick your school
  # 2) Enter your phone/email
  # 3) Confirm your phone
  # 4) Enter your credit card
  # 5) Foods page
  stateNavigator = ->
    # Step 1
    console.log($scope.user)
    if !$scope.user.school?
      $state.go("dashboard.activate.schools")
    # Step 4
    else if $scope.user.isActivated() && !$scope.user.payment_authorized
      $state.go("dashboard.activate.payment_method")
    # Step 2
    else if !$scope.user.phone
      return $state.go("dashboard.activate")
    # Step 3
    else if !$scope.user.isActivated()
      $state.go("dashboard.activate.confirm")
    # Step 5
    else
      $state.go('dashboard.foods')

  $scope.didSetSchool = ->
    stateNavigator()
    angular.element(".phone-field").trigger('focus')
  $scope.didSetPaymentMethod = ->
    stateNavigator()
  $scope.didConfirmPhone = ->
    $scope.user.confirmed = true
    stateNavigator()
  stateNavigator()

  


  $scope.startActivating = ->
    $scope.isActivating = true

    if $scope.activateForm.$invalid
      $scope.error = "Please re-enter your information and try again"
    else
      $scope.isActivating = true
  $scope.activate = ->
    return false if $scope.activateForm.$invalid
    $scope.isActivating = true

    Users.update id: $scope.user.id,
      phone: $scope.phone
      email: $scope.email
    , (user) ->
      Sessions.setCurrentUser(user)
      stateNavigator()
      $scope.reset()
    , (error) ->
      $scope.error = error.data.message

  $scope.reset = ->
    $scope.isActivating = false
    $scope.error = null
    $scope.phone = $scope.user.phone
    $scope.email = $scope.user.email

  $scope.reset()
