Module("IHP.Modals.PhoneModal", function(PhoneModal) {
  "use strict";

  PhoneModal.fn.initialize = function(el) {
    this.el = $("#phone_modal", el);
    this.number = $("#client_phone_number", el);
    this.form = $("form", el);
    this.assign();
    this.addEventListeners();
  };

  PhoneModal.fn.assign = function() {
    var phone = $("p#client_phone").text();
    $("input#client_phone_number", this.el).val(phone.replace("+1", ""));
    $("aside.form_validation_errors", this.el).remove();

    this.number.mask("999-999-9999");
    this.number.select();
    this.number.focus();
  };

  PhoneModal.fn.addEventListeners = function() {
    $("form", this.el).on("submit", function(e) {
      var number = $("#client_phone_number", this).val().replace("+1", "").replace(/ /g,"");
      $("#client_phone_number", this).val(number);
    });
  };
});
