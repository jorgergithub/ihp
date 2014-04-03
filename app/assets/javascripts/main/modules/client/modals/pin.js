Module("IHP.Modals.PinModal", function(PinModal) {
  "use strict";

  PinModal.fn.initialize = function(el) {
    this.el = $("#pin_modal", el);
    this.pin = $("#client_pin", el);
    this.assign();
  };

  PinModal.fn.assign = function() {
    this.pin.val(this.el.attr("data-pin"));
    $("aside.form_validation_errors", this.el).remove();
    this.pin.mask("####");
    this.pin.select();
    this.pin.focus();
  };
});
