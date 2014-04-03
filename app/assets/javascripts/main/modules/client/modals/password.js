Module("IHP.Modals.PasswordModal", function(PasswordModal) {
  "use strict";

  PasswordModal.fn.initialize = function(el) {
    this.el = $("#password_modal", el);
    this.new_password = $("#user_password", el);
    this.assign();
  };

  PasswordModal.fn.assign = function() {
    this.new_password.focus();
    $("aside.form_validation_errors", this.el).remove();
    $("form", this.el)[0].reset();
  };
});
