Module("IHP.Pages.AdminOrdersNew", function(AdminOrdersNew) {
  "use strict";

  AdminOrdersNew.fn.initialize = function(el) {
    Emitter.extend(this);

    // element
    this.el = $(el);

    // order form
    this.form = $(el).find("form");

    // form buttons
    this.submit = this.form.find("button.go");
    this.cancel = this.form.find("a.cancel");

    // sub components
    this.client  = IHP.Pages.Orders.AdminClient(this.form);
    this.package = IHP.Pages.Orders.Package(this.form);
    this.payment = IHP.Pages.Orders.Payment(this.form);

    this.addEventListeners();
  };

  AdminOrdersNew.fn.addEventListeners = function() {
    this.form.on("submit", this.whenFormSubmitted.bind(this));
    this.payment.on("paymentStarted", this.disableButtons, this);
    this.payment.on("paymentError", this.enableButtons, this);
  };

  AdminOrdersNew.fn.whenFormSubmitted = function() {
    return this.client.validate() &&
           this.package.validate() &&
           this.payment.validate();
  };

  AdminOrdersNew.fn.disableButtons = function() {
    this.submit.prop("disabled", true);
    this.cancel.hide();
  };

  AdminOrdersNew.fn.enableButtons = function() {
    this.submit.prop("disabled", false);
    this.cancel.show();
  };
});
