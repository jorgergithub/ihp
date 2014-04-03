Module("IHP.Modals.ResetPasswordModal", function (ResetPasswordModal) {
  "use strict";

  ResetPasswordModal.fn.initialize = function () {
    this.el = $("#reset_password_modal", "body");
    this.cancel = $(".close-button", this.el);
    this.addEventListeners();
  };

  ResetPasswordModal.fn.addEventListeners = function () {
    var redirectUrl = this.cancel.attr('href');

    this.cancel.one('click', function (event) {
      event.preventDefault();

      window.open(redirectUrl,"_self");
    });
  };
});
