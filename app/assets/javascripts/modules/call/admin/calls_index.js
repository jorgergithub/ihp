Module("IHP.Pages.AdminCallsIndex", function(AdminCallsIndex) {
  "use strict";

  AdminCallsIndex.fn.initialize = function(el) {
    Emitter.extend(this);

    IHP.Pages.AdminCalls(el);
  };
});
