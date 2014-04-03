describe("IHP.Pages.Orders.Payment", function() {
  var form, container, payment;
  var newCard, cardNumber, cardExpMonth, cardExpMonth, cardCvc;
  var cardNumberValidationError, cardExpirationDateValidationError,
      cardCvcValidationError, paymentError;
  var paypal;

  beforeEach(function() {
    form = $("<form action='/orders'/>").appendTo(".output");
    container = $("<div class='payment'/>").appendTo(form);

    newCard = $("<input type='radio' name='order[card_id]' id='order_card_id'/>").appendTo(container);
    cardNumber = $("<input id='order_card_number'/>").appendTo(container);
    cardExpMonth = $("<input id='order_card_exp_month'>").appendTo(container);
    cardExpYear = $("<input id='order_card_exp_year'>").appendTo(container);
    cardCvc = $("<input id='order_card_cvc'>").appendTo(container);

    cardNumberValidationError =
      $("<div id='card-number-validation-error'>").appendTo(container);
    cardExpirationDateValidationError =
      $("<div id='card-exp-date-validation-error'>").appendTo(container);
    cardCvcValidationError =
      $("<div id='card-cvc-validation-error'>").appendTo(container);

    paymentError = $("<div class='payment-errors'>").appendTo(container);

    paypal = $("<input type='radio' name='order[card_id]' id='order_paypal'/>").appendTo(container);

    payment = IHP.Pages.Orders.Payment(form);

    spyOn(form[0], "submit");
    spyOn(Stripe, "createToken");
  });

  describe("togglePayPal", function() {
    describe("when PayPal is selected", function() {
      beforeEach(function() {
        spyOn(payment, "setPayPal");
        payment.paypal.prop("checked", true);
      });

      it("calls setPayPal", function() {
        payment.togglePayPal();
        expect(payment.setPayPal).toHaveBeenCalled();
      });
    });

    describe("when PayPal isn't selected", function() {
      beforeEach(function() {
        spyOn(payment, "clearPayPal");
        payment.paypal.prop("checked", false);
      });

      it("calls clearPayPal", function() {
        payment.togglePayPal();
        expect(payment.clearPayPal).toHaveBeenCalled();
      });
    });
  });

  describe("setPayPal", function() {
    beforeEach(function() {
      payment.form.attr("action", "/orders");
      payment.form.removeAttr("data-remote");
      payment.setPayPal();
    });

    it("changes the form action to /orders/paypal", function() {
      expect(form.attr("action")).toEqual("/orders/paypal");
    });

    it("sets the form data-remote", function() {
      expect($("form[data-remote=true]").attr("action")).toEqual("/orders/paypal");
    });
  });

  describe("clearPayPal", function() {
    beforeEach(function() {
      payment.form.attr("action", "/orders/paypal");
      payment.form.attr("data-remote", true);
      payment.clearPayPal();
    });

    it("reverts the form action back to /orders", function() {
      expect(form.attr("action")).toEqual("/orders");
    });

    it("removes the form data-remote attribute", function() {
      expect($("form[data-remote=true]").length).toEqual(0);
    });
  });

  describe("setNumberValidationError", function() {
    it("sets the card number validation error text", function() {
      payment.setNumberValidationError("error");
      expect(cardNumberValidationError.text()).toEqual("error")
    });

    // it("sets focus to the card number", function() {
    //   payment.setNumberValidationError("error");
    //   expect(cardNumber.is(":focus")).toBeTruthy();
    // });
  });

  describe("setExpirateDateValidationError", function() {
    it("sets the expiration date validation error text", function() {
      payment.setExpirateDateValidationError("error");
      expect(cardExpirationDateValidationError.text()).toEqual("error")
    });
  });

  describe("setCvcValidationError", function() {
    it("sets the card cvc validation error text", function() {
      payment.setCvcValidationError("error");
      expect(cardCvcValidationError.text()).toEqual("error")
    });

    // it("sets focus to the card CVC", function() {
    //   payment.setCvcValidationError("error");
    //   expect(cardCvc.is(":focus")).toBeTruthy();
    // });
  });

  describe("setPaymentError", function() {
    it("sets the overall payment error text", function() {
      payment.setPaymentError("error");
      expect(paymentError.text()).toEqual("error")
    });
  });

  describe("clearErrors", function() {
    beforeEach(function() {
      cardNumberValidationError.text("error");
      cardExpirationDateValidationError.text("error");
      cardCvcValidationError.text("error");
      paymentError.text("error");

      payment.clearErrors();
    });

    it("clears the number error", function() {
      expect(cardNumberValidationError.text()).toEqual("");
    });

    it("clears the expiration date error", function() {
      expect(cardExpirationDateValidationError.text()).toEqual("");
    });

    it("clears the cvc error", function() {
      expect(cardCvcValidationError.text()).toEqual("");
    });

    it("clears the payment error", function() {
      expect(paymentError.text()).toEqual("");
    });
  });

  describe("validate", function() {
    beforeEach(function() {
      spyOn(payment, "clearErrors");
    });

    it("clears all the errors", function() {
      payment.validate();
      expect(payment.clearErrors).toHaveBeenCalled();
    });

    describe("when an existing card is selected", function() {
      beforeEach(function() {
        newCard.prop("checked", false);
      });

      it("returns true", function() {
        expect(payment.validate()).toBeTruthy();
      });
    });

    describe("when a new card is selected", function() {
      beforeEach(function() {
        newCard.prop("checked", true);
        spyOn(payment, "setNumberValidationError");
        spyOn(payment, "setExpirateDateValidationError");
        spyOn(payment, "setCvcValidationError");
      });

      describe("when card number is missing", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("");
          result = payment.validate();
        });

        it("sets number validation error", function() {
          expect(payment.setNumberValidationError).
            toHaveBeenCalledWith("please enter credit card number");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when card number is invalid", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("1234123412341234");
          result = payment.validate();
        });

        it("sets number validation error", function() {
          expect(payment.setNumberValidationError).
            toHaveBeenCalledWith("invalid credit card number");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when exp month is missing", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("4242424242424242");
          payment.cardExpMonth.val("");
          result = payment.validate();
        });

        it("sets exp month validation error", function() {
          expect(payment.setExpirateDateValidationError).
            toHaveBeenCalledWith("inform the expiration month");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when exp year is missing", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("4242424242424242");
          payment.cardExpMonth.val("08");
          payment.cardExpYear.val("");
          result = payment.validate();
        });

        it("sets exp year validation error", function() {
          expect(payment.setExpirateDateValidationError).
            toHaveBeenCalledWith("inform the expiration year");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when exp date is lower than current date", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("4242424242424242");
          payment.cardExpMonth.val("01");
          payment.cardExpYear.val("2010");
          result = payment.validate();
        });

        it("sets exp date validation error", function() {
          expect(payment.setExpirateDateValidationError).
            toHaveBeenCalledWith("your credit card has a expired date");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when missing CVC", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("4242424242424242");
          payment.cardExpMonth.val("12");
          payment.cardExpYear.val("2018");
          payment.cardCvc.val("");
          result = payment.validate();
        });

        it("sets number validation error", function() {
          expect(payment.setCvcValidationError).
            toHaveBeenCalledWith("please enter 3-digit CVC");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when CVC is short", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("4242424242424242");
          payment.cardExpMonth.val("12");
          payment.cardExpYear.val("2018");
          payment.cardCvc.val("12");
          result = payment.validate();
        });

        it("sets number validation error", function() {
          expect(payment.setCvcValidationError).
            toHaveBeenCalledWith("please enter 3-digit CVC");
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });

      describe("when card, expiration date and CVC are valid", function() {
        var result;

        beforeEach(function() {
          payment.cardNumber.val("4242424242424242");
          payment.cardExpMonth.val("12");
          payment.cardExpYear.val("2018");
          payment.cardCvc.val("123");
          result = payment.validate();
        });

        it("doesn't set the number validation error", function() {
          expect(payment.setNumberValidationError).not.toHaveBeenCalled();
        });

        it("doesn't set the expiration date validation error", function() {
          expect(payment.setExpirateDateValidationError).not.toHaveBeenCalled();
        });

        it("doesn't set the CVC validation error", function() {
          expect(payment.setCvcValidationError).not.toHaveBeenCalled();
        });

        it("returns false", function() {
          expect(result).toBeFalsy();
        });
      });
    });
  });

  describe("stripeResponseHandler", function() {
    describe("when success", function() {
      beforeEach(function() {
        spyOn(form, "submit");

        var success = { id: "TOKEN", error: false };
        payment.stripeResponseHandler(200, success);
      });

      it("appends the token to the form", function() {
        expect(form.find("[name='order[stripe_token]']").val()).toEqual("TOKEN");
      });

      it("submits the form", function() {
        expect(form[0].submit).toHaveBeenCalled();
      });
    });

    describe("when failure", function() {
      beforeEach(function() {
        spyOn(payment, "setPaymentError");

        var failure = { error: { message: "ERROR" } };
        payment.stripeResponseHandler(200, failure);
      });

      it("sets the payment error", function() {
        expect(payment.setPaymentError).toHaveBeenCalledWith("ERROR");
      });
    });
  });
});
