Module("IHP.Pages.HomeCareers", function(HomeCareers) {
  "use strict";

  HomeCareers.fn.initialize = function(el) {
    this.el = $($(el).find(".careers aside"));
    this.articles = $($(el).find("article"));
    this.tab = $("section.careers").attr("data-selected-tab");
    this.tab = this.tab || this.extractTab(document.location.toString())
    this.tab = this.tab || "main";
    this.addEventListeners();
    this.displayProperTab();

    $("#application_phone").mask("999-999-9999");
  };

  HomeCareers.fn.addEventListeners = function() {
    this.el.on("click", "li", this.changeSelection.bind(this));
    this.articles.on("click", ".inner-link", this.changeSelection.bind(this));
  };

  HomeCareers.fn.changeSelection = function(e) {
    e.preventDefault();

    var link = this.extractTab($(e.target).attr("href"));

    $(".careers aside ul li.selected").removeClass("selected");
    $(".careers-link-" + link).addClass("selected");
    $(".careers article.selected").removeClass("selected");
    $(".careers article.careers-" + link).addClass("selected");

    location.hash = link;
  };

  HomeCareers.fn.displayProperTab = function() {
    var liEl = $(".careers-link-" + this.tab);
    var articleEl = $(".careers-" + this.tab);

    liEl.addClass("selected");
    articleEl.addClass("selected");
  };

  HomeCareers.fn.extractTab = function(s) {
    var parts = s.split("#");
    if (parts.length > 1) {
      return parts[1];
    }
    else {
      return null;
    }
  };
});

IHP.Pages.ApplicationsNew = IHP.Pages.HomeCareers;
