$(document).ready(function() {
  if (!$('body.home').length) {
    return;
  }

  $('#faq-button').click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    $(".overlay").fadeIn();
    $('#faq-modal').fadeIn();
  });

  $('.close-button').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    $("#confirmation-modal").fadeOut();
    $("#faq-modal").fadeOut();
    $('.overlay').fadeOut();
  });

  $("#subscribe").click(function(e) {
    e.preventDefault();
    e.stopPropagation();

    $("form").submit();
  });
});
