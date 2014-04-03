Module("IHP.Pages.PsychicsAbout", function(PsychicsAbout) {
  "use strict";

  PsychicsAbout.fn.initialize = function(el) {
    console.log("PsychicsAbout initialized");
    this.el = el;
    this.addEventListeners();

    Module.run("IHP.Components.Scrollbar");
  };

  PsychicsAbout.fn.addEventListeners = function() {
    this.el.on("click", ".psychics-call-back", this.whenCallbackIsClicked.bind(this));
  }

  PsychicsAbout.fn.whenCallbackIsClicked = function(e) {
    e.preventDefault();
    var psychicId = $("#psychic-details").attr("data-psychic-id");
    Module.run("IHP.Components.Callbacks", [this.el, psychicId]);
  };

});
