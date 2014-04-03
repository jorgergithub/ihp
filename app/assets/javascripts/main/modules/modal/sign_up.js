Module("IHP.Modals.SignUpModal", function(SignUpModal) {
  "use strict";

  SignUpModal.fn.initialize = function(attributes) {
    this.el = $("#sign_up_modal", "body");
    this.first_name = $("#user_first_name", this.el);
    this.phone = $("#user_client_attributes_phones_attributes_0_number");
    this.errors = $(".form_validation_errors", this.el);
    this.assign();
  };

  SignUpModal.fn.assign = function() {
    $("form", this.el)[0].reset();
    $("form input[type='text']", this.el).val("");
    $("form select option", this.el).attr("selected", false)
    this.first_name.focus();
    this.errors.remove();
    this.phone.mask("999-999-9999");
    Module.run("IHP.Components.Scrollbar");
  };
});