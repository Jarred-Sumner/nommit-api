this.nommit.filter('tel', function () {
  return function (phoneNumber) {
    if (!phoneNumber) return phoneNumber;
    return formatLocal('US', phoneNumber);
  }
});
