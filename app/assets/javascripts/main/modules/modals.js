$(document).ready(function() {
  $("body").on("click", ".modal_link", function(e) {
    e.preventDefault();

    var modalId = $(this).data("modal-id");
    var modalAttributes = $(this).data("modal-attributes");

    showModal(modalId, modalAttributes)
  });

  $("a[data-close-modal]").on("click",  function(e) {
    e.preventDefault();
    var selector = $(this).attr("data-close-modal");
    var el = $(selector);

    $(".overlay").fadeOut();
  });
});

window.showModal = function(modalId, modalAttributes) {
  Module.run("IHP.Main.Modal.Modal", [modalId, modalAttributes]);
}