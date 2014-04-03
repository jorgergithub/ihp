$(document).ready(function() {
  $('#horoscope_date').datepicker({
    format: 'yyyy-mm-dd'
  }).on('changeDate', function(e) {
    var date = $(this).val();
    location.href = "/admin/horoscopes/" + date + "/edit";
  });
});
