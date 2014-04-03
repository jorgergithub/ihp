Module("IHP.Components.CallbackModal", function(CallbackModal) {
  "use strict";

  CallbackModal.fn.initialize = function(el, psychicId) {
    this.el = $(el.find("#callback-modal"));
    this.overlay = $(el.find(".overlay"));

    this.psychicId = $(el.find("#callback_psychic_id"));
    this.psychicId.val(psychicId);

    this.addEventListeners();
  };

  CallbackModal.fn.addEventListeners = function() {
    this.el.on("click", ".callback-modal-cancel", this.whenCancelIsClicked.bind(this));
    this.el.on("click", ".callback-modal-schedule", this.whenScheduleIsClicked.bind(this));
  };

  CallbackModal.fn.show = function() {
    this.el.fadeIn();
    this.overlay.fadeIn();
  };

  CallbackModal.fn.hide = function() {
    this.el.fadeOut();
    this.overlay.fadeOut();
  };

  CallbackModal.fn.whenScheduleIsClicked = function(e) {
    e.preventDefault();
    $(".callback-modal-form").trigger("submit.rails");
  };

  CallbackModal.fn.whenCancelIsClicked = function(e) {
    e.preventDefault();
    this.hide();
  };
});

Module("IHP.Components.Callbacks", function(Callbacks) {
  "use strict";

  Callbacks.fn.initialize = function(el, psychicId) {
    this.el = el;
    this.psychicId = psychicId;
    this.modal = IHP.Components.CallbackModal(this.el, psychicId);
    this.modal.show();
  };
});
