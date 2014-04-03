Module("IHP.Modals.BirthdayModal", function(BirthdayModal) {
  "use strict";

  BirthdayModal.fn.initialize = function(el) {
    this.el = $("#birthday_modal", el);
    this.day = $("#user_client_attributes_birthday_3i", el);
    this.month = $("#user_client_attributes_birthday_2i", el);
    this.year = $("#user_client_attributes_birthday_1i", el);
    this.timezone = $("#user_time_zone", el);

    this.assign();
  };

  BirthdayModal.fn.assign = function() {
    this.day.val(this.el.attr("data-day"));
    this.month.val(this.el.attr("data-month"));
    this.year.val(this.el.attr("data-year"));
    this.timezone.val(this.el.attr("data-timezone"));
  };
});
