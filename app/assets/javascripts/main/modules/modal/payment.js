Module("IHP.Main.Modal.Payment", function(Payment) {
  "use strict";

  Payment.fn.initialize = function(el) {
    Emitter.extend(this);

    this.form = el;
    this.el = $(el);

    this.newCard = this.el.find("#order_card_id");
    this.cardNumber = this.el.find("#order_card_number");
    this.cardExpMonth = this.el.find("#order_card_exp_month");
    this.cardExpYear = this.el.find("#order_card_exp_year");
    this.cardCvc = this.el.find("#order_card_cvc");

    this.validationError = this.el.find("aside.form_validation_errors ul li");

    this.el.off("submit").on("submit", this.validate.bind(this));
  };

  Payment.fn.setValidationError = function(error) {
    this.validationError.text(error);
  };

  Payment.fn.clearErrors = function() {
    this.setValidationError("");
  }

  Payment.fn.validate = function(e) {

    this.clearErrors();

    // missing card number
    if (!this.cardNumber.val()) {
      this.setValidationError("please enter credit card number");
      return false;
    }

    // invalid card number
    if (!Stripe.validateCardNumber(this.cardNumber.val())) {
      this.setValidationError("invalid credit card number");
      return false;
    }

    // invalid exp month
    if (!this.cardExpMonth.val()) {
      this.setValidationError("inform the expiration month");
      return false;
    }

    // invalid exp year
    if (!this.cardExpYear.val()) {
      this.setValidationError("inform the expiration year");
      return false;
    }

    // invalid exp date (lower than current date)
    if (!Stripe.validateExpiry(this.cardExpMonth.val(), this.cardExpYear.val())) {
      this.setValidationError("your credit card has a expired date");
      return false;
    }

    // missing or short CVC number
    var cvcVal = this.cardCvc.val();
    if ((!cvcVal)||(cvcVal.length < 3)) {
      this.setValidationError("please enter 3-digit CVC");
      return false;
    }

    return this.charge(e);
  };

  Payment.fn.stripeResponseHandler = function(status, response) {
    if (response.error) {
      this.emit("paymentError");

      this.setValidationError(response.error.message);
    }
    else {
      this.emit("paymentSuccess");

      var tokenId = response.id;
      var token = $("<input type='hidden' name='order[stripe_token]'>").val(tokenId);

      $(this.form).append(token);
      $(this.form).trigger('submit.rails');
    }
  };

  Payment.fn.charge = function(e) {
    this.emit("paymentStarted");
    window.onModalFormSubmit(e);
    Stripe.createToken(this.form, this.stripeResponseHandler.bind(this));
    return false;
  };
});
