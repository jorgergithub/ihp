Module("IHP.Pages.Orders.Package", function(Package) {
  "use strict";

  Package.fn.initialize = function(el) {
    this.el = el.find(".package");
    this.radios = this.el.find("[name='order[package_id]']");
    this.error = this.el.find('#package-validation-error');

    this.addEventListeners();
  };

  Package.fn.addEventListeners = function() {
    this.radios.on("change", function() {
      this.clearError();
    }.bind(this));
  };

  Package.fn.clearError = function() {
    this.error.text("");
  };

  Package.fn.displayError = function() {
    this.error.text("please select a package");
  };

  Package.fn.validate = function() {
    this.clearError();

    var selectedPackage = this.el.find("[name='order[package_id]']:checked");
    if (selectedPackage.length > 0) {
      return true;
    }

    this.displayError();
    return false;
  };
});
