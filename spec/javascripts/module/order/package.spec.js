describe("IHP.Pages.Orders.Package", function() {
  var form, container, error, package, package_radio;

  beforeEach(function() {
    form = $("<form/>").appendTo(".output");
    container = $("<div class='package'/>").appendTo(form);
    error = $("<div id='package-validation-error'/>").appendTo(container);

    package_radio =
      $("<input type='radio' name='order[package_id]'>").appendTo(container);

    package = IHP.Pages.Orders.Package(form);
  });

  describe("clearError", function() {
    beforeEach(function() {
      error.text("some error");
    });

    it("clears the validation error", function() {
      package.clearError();
      expect(error.text()).toEqual("");
    });
  });

  describe("displayError", function() {
    beforeEach(function() {
      error.text("");
    });

    it("sets the validation error text", function() {
      package.displayError();
      expect(error.text()).toEqual("please select a package");
    });
  });

  describe("validate", function() {
    var result;

    beforeEach(function() {
      spyOn(package, "clearError");
      spyOn(package, "displayError");
    });

    it("clears the errors", function() {
      package.validate();
      expect(package.clearError).toHaveBeenCalled();
    });

    describe("when no package is selected", function() {
      it("displays the error", function() {
        package.validate();
        expect(package.displayError).toHaveBeenCalled();
      });

      it("returns false", function() {
        expect(package.validate()).toBeFalsy();
      });
    });

    describe("when a package is selected", function() {
      beforeEach(function() {
        package_radio.prop("checked", true);
      });

      it("returns true", function() {
        expect(package.validate()).toBeTruthy();
      });
    });
  });
});
