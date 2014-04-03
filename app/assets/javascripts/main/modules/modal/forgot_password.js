Module("IHP.Modals.ForgotPasswordModal", function(Modal) {
  "use strict";

  Modal.fn.initialize = function(modalAttributes) {
    this.el = $("#forgot_password_modal", "body");
    this.showErrors = false;

    if (modalAttributes) {
      this.showErrors = modalAttributes["withErrors"] 
    }

    this.assign();
    this.addEventListeners();
  };

  Modal.fn.assign = function() {
    if (this.showErrors) {
      this.showInvalidPasswordError()
    } else {
      $(".form_validation_errors", this.el).hide();
      $("form", this.el)[0].reset();
    }
  };

  Modal.fn.addEventListeners = function() {
    this.el.off("ajax:error", "form").on("ajax:error", "form", this.showInvalidPasswordError.bind(this));
  };

  Modal.fn.showInvalidPasswordError = function(e) {
    $(".form_validation_errors", this.el).html("<ul><li>Email not found.</li></ul>");
    $(".form_validation_errors", this.el).show();
  };
});