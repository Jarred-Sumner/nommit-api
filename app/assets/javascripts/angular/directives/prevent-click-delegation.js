// Thanks http://stackoverflow.com/questions/15193539/whats-the-best-way-to-cancel-event-propagation-between-nested-ng-click-calls
this.nommit.directive('preventClickDelegation', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attr) {
            element.bind('click', function (e) {
                e.stopPropagation();
            });
        }
    };
 });
