Module("IHP.Pages.AdminPsychicsUpdate", function(Psychic) {
  "use strict";

  Psychic.fn.initialize = function(el) {
    Emitter.extend(this);

    // element
    this.el = $(el);

    // psychic form
    this.form = $(el).find("form");

    // sub components
    this.country = IHP.Pages.Commons.Country(this.form);
  };
});
