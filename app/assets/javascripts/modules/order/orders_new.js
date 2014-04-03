Module("IHP.Pages.OrdersNew", function(OrdersNew) {
  "use strict";

  OrdersNew.fn.initialize = function(el) {
    Emitter.extend(this);

    // element
    this.el = $(el);

    // order form
    this.form = $(el).find("form");

    // form buttons
    this.submit = this.form.find("button.go");
    this.cancel = this.form.find("a.cancel");

    // sub components
    this.package = IHP.Pages.Orders.Package(this.form);
    this.payment = IHP.Pages.Orders.Payment(this.form);

    this.addEventListeners();
  };

  OrdersNew.fn.addEventListeners = function() {
    this.form.on("submit", this.whenFormSubmitted.bind(this));
    this.payment.on("paymentStarted", this.disableButtons, this);
    this.payment.on("paymentError", this.enableButtons, this);
  };

  OrdersNew.fn.whenFormSubmitted = function() {
    return this.package.validate() && this.payment.validate();
  };

  OrdersNew.fn.disableButtons = function() {
    this.submit.prop("disabled", true);
    this.cancel.hide();
  };

  OrdersNew.fn.enableButtons = function() {
    this.submit.prop("disabled", false);
    this.cancel.show();
  };
});
