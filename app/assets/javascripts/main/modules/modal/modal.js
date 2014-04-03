Module("IHP.Main.Modal.Modal", function(Modal) {
  "use strict";

  Modal.fn.MODAL_FADE = 400

  Modal.fn.initialize = function(modalId, modalAttributes) {
    this.modalId = modalId;
    this.el = $("#" + modalId);

    this.assign();
    Module.run("IHP.Modals." + this.camelizedModalId(), [modalAttributes]);
    this.addEventListeners();
  };

  Modal.fn.assign = function() {
    $(".spinner_overlay", this.el).hide();
    var modal = this.el;
    if ($(".modal").is(":visible")) {
      $(".modal:visible").fadeOut(Modal.MODAL_FADE, function () {
        modal.fadeIn(Modal.MODAL_FADE);
        Module.run("IHP.Components.Scrollbar");
      });
    } else {
      this.el.fadeIn(Modal.MODAL_FADE);
      $(".overlay").fadeIn(Modal.MODAL_FADE);
    }

    Module.run("IHP.Components.Scrollbar");
    $("input[type='checkbox']:checked + label", this.el).addClass("label-checked");
  };

  Modal.fn.camelizedModalId = function() {
    var parts = this.modalId.split("_");
    var camelized = "";
    for (var i = 0; i < parts.length; i++) {
      var string = parts[i];
      camelized += string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
    }
    return camelized;
  };

  Modal.fn.addEventListeners = function() {
    this.bindCloseModal();
    $("body").off("click", ".overlay").on("click", ".overlay", closeModal);
    this.el.off("click", ".close-button").on("click", ".close-button", closeModal);
    this.el.off("submit", "form").on("submit", "form", this.onFormSubmit);
    this.el.off("ajax:complete", "form").on("ajax:complete", "form", this.onAjaxComplete.bind(this));
    this.el.on("change", "input[type='checkbox']", function() {
      $(this).siblings("label").toggleClass("label-checked");
    });
    this.el.on("click", "a.reset_form", this.resetForm.bind(this));
  };

  Modal.fn.bindCloseModal = function() {
    window.closeModal = function(e) {
      if (e) e.preventDefault();
      $(".modal").fadeOut(Modal.MODAL_FADE, function() {
        $(".modal").trigger("dismiss");
      });
      $(".overlay").fadeOut(Modal.MODAL_FADE);
    }
  };

  window.onModalFormSubmit = function(e) {
    var $form = $(e.target);
    var $submitButtons = $("input[type='image']", $form);
    var $spinner = $(".spinner_overlay");

    $("body").off("click", ".overlay");

    $submitButtons.prop("disabled", true);
    $spinner.fadeIn();
  }

  Modal.fn.onFormSubmit = function(e) {
    window.onModalFormSubmit(e);
  };

  Modal.fn.onAjaxComplete = function(e, xhr, status) {
    var $form = $(e.target);
    var $submitButtons = $("input[type='image']", $form);

    this.addEventListeners();
    $submitButtons.prop("disabled", false);

    if (!$form.attr("data-keepspinner")) {
      $(".spinner_overlay").fadeOut();
    }
  };

  Modal.fn.resetForm = function(e) {
    e.preventDefault();
    var button = $(e.target);
    button.closest("form")[0].reset();
  };
});
