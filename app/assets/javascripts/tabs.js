$(document).ready(function() {
  $('#tabs').bind('click', function (e) {
    var $target = $(e.target);
    var selector = $target.attr('href')
    var content = $(selector);

    $('.tab-pane').removeClass('active');

    $target.tab('show');
    return false;
  });

  $('.nav-tabs a').on('shown', function (e) {
    var form = $('form'),
        hash = e.target.hash;

    if (history.pushState) {
      history.pushState(null, null, hash);
    } else {
      window.location.hash = hash;
    }

    if (form.prop('action')) {
      var action = form.prop('action');

      if (action.match(/#/)) {
        action = action.replace(/#.+/g, hash);
      } else {
        action += hash;
      }

      form.prop('action', action);
    }

    $('#anchor').val(hash.replace(/#/, ""));
  })

  if (window.location.hash) {
    $('a[href=' + location.hash + ']').tab('show');
  }
});

$(window).on('popstate', function() {
  var anchor = window.location.hash || $("a[data-toggle=tab]").first().attr("href");
  $('a[href=' + anchor + ']').tab('show');
});
