$(document).ready(function() {
  if (!$('body.psychic_applications').length) {
    return;
  }

  function changeHowDidYouHear() {
    var val = $('#psychic_application_how_did_you_hear option:selected').text();
    if (val == 'Other') {
      $('#other').show();
      $('#other input').removeAttr('disabled');
      $('#other input').focus();
    }
    else {
      $('#other input').attr('disabled', 'disabled');
      $('#other').hide();
    }
  }

  $('#psychic_application_how_did_you_hear').change(changeHowDidYouHear);
  changeHowDidYouHear();

  $('.submit').click(function(e) {
    $('form').submit();
  });
});
