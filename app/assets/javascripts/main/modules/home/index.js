Module("IHP.Pages.HomeIndex", function(HomeIndex) {
  "use strict";

  HomeIndex.fn.initialize = function(el) {
    this.el = $(el);
    this.search = Module.run("IHP.Components.PsychicSearch", [this.el]);

    this.addEventListeners();
  };

  HomeIndex.fn.addEventListeners = function() {
    this.el.on("click", ".sign_up_link", this.redirectToSignup);

    $(window).scroll(this.activateNavigationItem);
  };

  HomeIndex.fn.redirectToSignup = function(e) {
    e.preventDefault();
    window.location.href = "/users/sign_up";
  };

  HomeIndex.fn.activateNavigationItem = function() {
    function isOnScreen(element) {
      var elementTop = element.offset().top;
      var elementBottom = elementTop + element.height();

      var scrollTop = $(window).scrollTop();
      var scrollBottom = scrollTop + $(window).height();

      return (elementTop < scrollBottom) && (elementBottom > scrollTop);
    }

    $("li.nav-link").removeClass("active");
    
    if (isOnScreen($('.container-psychics'))) {
      $("li.search_link").addClass("active");
    } else if (isOnScreen($('.container-offers'))) {
      $("li.offers_link").addClass("active");
    } else {
      $("li.home_link").addClass("active");
    };
  };
});

Module("IHP.Pages.HomeContact", function(HomeIndex) {
  "use strict";

  HomeIndex.fn.initialize = function(el) {
    this.el = $(el);
    $("#message_phone", this.el).mask("999-999-9999");
  };
});
