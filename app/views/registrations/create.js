$("#registration_pixel_conversion").remove()
var marinConversionPixel = "<%= escape_javascript render('registrations/registration_conversion_pixel') %>";
$(marinConversionPixel).insertAfter($("#sign_up_success_modal"));

showModal("sign_up_success_modal");