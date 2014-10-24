@nommit.directive "profilePic", ($timeout) ->
  {
    restrict: "A"
    scope: {
      profilePic: "@profilePic"
      size: '@size'
    }
    link: (scope, element, attrs) ->
      setSrc = (profileID, size) ->
        url = null
        if size == "large" || size == "small"
          url = "https://graph.facebook.com/#{profileID}/picture?type=#{size}"
        else
          width = size.split("x")[0]
          height = size.split("x")[1]
          url = "https://graph.facebook.com/#{profileID}/picture?width=#{width}&height=#{height}"

        attrs.$set("src", url)

      scope.$watch ->
        [attrs.profilePic, attrs.size]
      , ->
        setSrc(attrs.profilePic, attrs.size)
      , true
  }
