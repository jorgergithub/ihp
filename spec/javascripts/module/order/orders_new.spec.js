describe("IHP.Pages.OrdersNew", function() {
  var container, submit, cancel;
  var package, payment, orders_new;

  beforeEach(function() {
    container = $("<div/>").appendTo(".output")
    form = $("<form onsubmit='return false;' />").appendTo(container);
    submit = $("<button class='go'>").appendTo(form);
    cancel = $("<a class='cancel'>").appendTo(form);

    package = jasmine.createSpyObj("package", ["validate"]);
    package.validate.and.callReturn(false);

    payment = jasmine.createSpyObj("package", ["validate"]);
    package.validate.and.callReturn(false);
    Emitter.extend(payment);

    spyOn(IHP.Pages.Orders, "Package").and.callReturn(package);
    spyOn(IHP.Pages.Orders, "Payment").and.callReturn(payment);

    orders_new = IHP.Pages.OrdersNew(container);
  });

  describe("when the form is submitted", function() {
    var event;

    beforeEach(function() {
      event = $.Event;
      event.type = "submit";
    });

    it("validates the package", function() {
      form.trigger(event);
      expect(package.validate).toHaveBeenCalled();
    });

    it("validates the payment", function() {
      package.validate.and.callReturn(true);

      form.trigger(event);
      expect(payment.validate).toHaveBeenCalled();
    });
  });

  describe("handling paymentStarted event", function() {
    it("disable submit button", function() {
      payment.emit("paymentStarted");
      expect(submit.prop("disabled")).toBeTruthy();
    });

    it("hides cancel button", function() {
      payment.emit("paymentStarted");
      expect(cancel.is(":visible")).toBeFalsy();
    });
  });

  describe("handling paymentError event", function() {
    it("enables submit button", function() {
      payment.emit("paymentError");
      expect(submit.prop("disabled")).toBeFalsy();
    });

    it("shows cancel button", function() {
      payment.emit("paymentError");
      expect(cancel.is(":visible")).toBeTruthy();
    });
  });
});
