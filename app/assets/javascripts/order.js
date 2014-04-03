// var stripeResponseHandler = function(status, response) {
//   var $form = $('#new_order');

//   if (response.error) {
//     // Show the errors on the form
//     $form.find('.payment-errors').text(response.error.message);
//     $form.find('button').prop('disabled', false);
//     $('.cancel').show();
//   }
//   else {
//     // token contains id, last4, and card type
//     var token = response.id;
//     // Insert the token into the form so it gets submitted to the server
//     $form.append($('<input type="hidden" name="order[stripe_token]" />').val(token));
//     // and re-submit
//     $form.get(0).submit();
//   }
// };

// $(document).ready(function() {
//   if ($('#new_order').length) {
//     $('#new_order').submit(function(e) {
//       var $form = $(this);

//       $('#package-validation-error').text("");
//       $('#card-number-validation-error').text("");
//       $('#card-cvc-validation-error').text("");

//       if ($('[name="order[package_id]"]:checked').length < 1) {
//         $('#package-validation-error').text("please select a package");
//         return false;
//       }

//       if ($('#order_card_id').is(':checked')) {
//         var card_number = $('#order_card_number').val();
//         var card_exp_month = $('#order_card_exp_month').val();
//         var card_exp_year = $('#order_card_exp_year').val();
//         var card_cvc = $('#order_card_cvc').val();

//         if (!card_number) {
//           $('#card-number-validation-error').text("please enter credit card number");
//           $('#order_card_number').focus();
//           return false;
//         }

//         if (!Stripe.validateCardNumber(card_number)) {
//           $('#card-number-validation-error').text("invalid credit card number");
//           $('#order_card_number').focus();
//           return false;
//         }

//         if ((!card_cvc)||(card_cvc.length < 3)) {
//           $('#card-cvc-validation-error').text("please enter 3-digit CVC");
//           $('#order_card_cvc').focus();
//           return false;
//         }
//       }

//       // Disable the submit button to prevent repeated clicks
//       $form.find('button').prop('disabled', true);
//       $('.cancel').hide();

//       // If user is using an existing card
//       if (!$('#order_card_id').is(':checked')) {
//         return true;
//       }

//       Stripe.createToken($form, stripeResponseHandler);

//       // Prevent the form from submitting with the default action
//       return false;
//     });
//   }
// });
