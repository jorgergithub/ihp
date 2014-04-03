(function($) {

  // adds clamp as a jQuery plugin
  $.fn.clamp = function(clamp_arg) {
    return this.each(function() {

      // IE hates Clamp.js :/
      try {
        $clamp(this, {clamp: clamp_arg});
      }
      catch (e) {}

    });
  };

}(jQuery));

$(document).ready(function() {
  // clamps all elements with clamp class
  $(".clamp").clamp("auto");
});
