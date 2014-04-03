$(document).ready(function() {
  var nav = $(document).find('.nav'),
      navTop = nav.position().top,
      win = $(window);

  $(this).scroll(function () {
    if(win.scrollTop() > navTop){
      nav.addClass('position-fixed');
    }else{
      nav.removeClass('position-fixed');
    }
  });
});
