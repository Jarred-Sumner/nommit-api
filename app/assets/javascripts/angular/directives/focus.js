// Thanks http://www.marushkevych.com/2014/05/21/angular-focus-on-input/
this.nommit.directive("focus", function($timeout) {
  return {
    scope: {
      focus: '@'
    },
    link: function(scope, element) {
      function doFocus() {
        $timeout(function() {
          element[0].focus();
        });
      }

      if (scope.focus != null)
      {
        // focus unless attribute evaluates to 'false'
        if (scope.focus !== 'false') {
          doFocus();
        }

        // focus if attribute value changes to 'true'
        scope.$watch('focus', function(value) {
          if (value === 'true') {
            doFocus();
          }
        });
      }
      else {
        // if attribute value is not provided - always focus
        doFocus();
      }

    }
  };
});
