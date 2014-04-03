Module("IHP.Modals.PsychicEditProfileModal", function(PsychicEditProfileModal) {
  "use strict";

  PsychicEditProfileModal.fn.initialize = function(el) {
    this.el = $("form.edit_psychic", el);
    this.phoneNumber = $("#psychic_phone", el);
    this.phoneNumber.mask("999-999-9999");
  };
});
