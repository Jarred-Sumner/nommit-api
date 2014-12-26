//= require jquery

$(function() {

  function cycleImages() {
    var order = ['.first', '.second', '.third', '.fourth', '.fifth'];

    var active = $(".ken-burns.active");
    var classes = $(".ken-burns.active").attr("class").split(" ");
    var index = -1;

    for (var i = classes.length - 1; i >= 0; i--) {
      var className = classes[i];
      if (order.indexOf("." + className) > -1) {
        index = order.indexOf("." + className) + 1;
        break;
      }
    }

    if (index == order.length - 1) {
      index = 0;
    }

    var next = $(".ken-burns" + order[index]);

    $(active).fadeOut(3000, function() {
      $(active).removeClass("active")
    });

    $(next).hide()
    $(next).addClass("active");
    $(next).fadeIn(3000);

  }

  setInterval(cycleImages, 7000);
});