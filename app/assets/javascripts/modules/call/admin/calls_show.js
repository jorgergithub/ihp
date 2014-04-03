Module("IHP.Pages.AdminCallsShow", function(AdminCallsShow) {
  "use strict";

  AdminCallsShow.fn.initialize = function(el) {
    Emitter.extend(this);

    IHP.Pages.AdminCalls(el);
  };
});
