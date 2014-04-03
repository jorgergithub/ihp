$("#sign_up_modal form").trigger("ajax:complete");
$("#sign_up_modal form").replaceWith("<%= escape_javascript(render 'registrations/create_form', user: @user ) %>");

var phone = $("#user_client_attributes_phones_attributes_0_number").val().replace("+1","");
$("#user_client_attributes_phones_attributes_0_number").val(phone);
$("#user_client_attributes_phones_attributes_0_number").mask("999-999-9999");

Module.run("IHP.Components.Scrollbar");