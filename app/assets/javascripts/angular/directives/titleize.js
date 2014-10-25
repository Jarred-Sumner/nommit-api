this.nommit.filter('titleize', function () {
  return function (string) {
    if (!string) return string;
    return _.str.titleize(string);
  }
});
