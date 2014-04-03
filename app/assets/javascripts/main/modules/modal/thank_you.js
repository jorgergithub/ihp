Module("IHP.Modals.ThankYouModal", function (Modal) {
  "use strict";

  Modal.fn.initialize = function () {
    this.el = $("#thank_you_modal", "body");
    this.addEventListeners();
  };

  Modal.fn.addEventListeners = function () {
    $("a.dismiss_modal", this.el).on("click", function() {
      console.log("should close modal");
      closeModal();
    })
  };
});
