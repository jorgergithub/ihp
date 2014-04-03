Module("IHP.Pages.AdminCalls", function(AdminCalls) {
  "use strict";

  AdminCalls.fn.initialize = function(el) {
    Emitter.extend(this);

    this.select = jQuery("#client_id");

    this.addEventListeners();
  };

  AdminCalls.fn.addEventListeners = function() {
    this.select.on("change", function() {
      var url = this.select.attr("rel");
      var selectedClient = this.select.val();

      jQuery.get(url + selectedClient);
    }.bind(this));
  };
});
