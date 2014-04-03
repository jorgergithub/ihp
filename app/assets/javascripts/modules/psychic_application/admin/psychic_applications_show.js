Module("IHP.Pages.AdminPsychicApplicationsShow", function(PsychicApplication) {
  "use strict";

  PsychicApplication.fn.initialize = function(el) {
    Emitter.extend(this);

    // element
    this.el = $(el);

    // psychic application form
    this.form = $(el).find("form");

    // sub components
    this.country = IHP.Pages.Commons.Country(this.form);
  };
});
