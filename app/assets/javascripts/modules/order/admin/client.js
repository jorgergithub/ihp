Module("IHP.Pages.Orders.AdminClient", function(AdminClient) {
  "use strict";

  AdminClient.fn.initialize = function(el) {
    this.el = el.find(".client");
    this.select = el.find("#order_client_id");
    this.payment = el.find("#client-payment")
    this.error  = el.find("#order-client-validation-error");

    this.addEventListeners();
  };

  AdminClient.fn.addEventListeners = function() {
    this.select.on("change", function() {
      var isValid = this.validate();

      if (isValid) {
        var url = this.select.attr("rel");
        var selectedClient = this.select.val();
        jQuery.get(url + selectedClient);
      } else {
        this.payment.empty();
      }
    }.bind(this));
  };

  AdminClient.fn.clearError = function() {
    this.error.text("");
  };

  AdminClient.fn.displayError = function() {
    this.error.text("please select a client");
  };

  AdminClient.fn.validate = function() {
    this.clearError();

    var selectedClient = this.select.val();

    if (selectedClient) {
      return true;
    }

    this.displayError();
    return false;
  };
});
