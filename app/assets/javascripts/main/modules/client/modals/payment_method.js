Module("IHP.Modals.SelectPaymentMethodModal", function(SelectPaymentMethodModal) {
  "use strict";

  SelectPaymentMethodModal.fn.initialize = function(attributes) {
    this.el = $("#select_payment_method_modal");
    this.selectCardPanel    = $(".select_card_panel", this.el);
    this.creditCardsPanel   = $(".credit_cards_panel", this.el);
    this.paypalPanel        = $(".paypal_panel", this.el);
    this.newCreditCardPanel = $(".new_credit_card_panel", this.el);

    this.package            = attributes.package;

    this.assign();
    this.initNewCreditCardPayment();
    this.bindNavigation();
    this.cardSelection();
    this.cardTypeFlagHandler();
    this.addEventListeners();
  };

  SelectPaymentMethodModal.fn.addEventListeners = function() {
    $("ul.credit_cards li .cc_actions a.delete_card", this.el).on("ajax:send",this.deleteCard.bind(this));
  };

  SelectPaymentMethodModal.fn.cardTypeFlagHandler = function() {
    var changeCreditCardIcon = function(el) {
      var number = $(el).val();
      var type = Stripe.card.cardType(number);

      if (type === "American Express") {
        var cardType = "american_express"
      } else if (type === "Visa") {
        var cardType = "visa"
      } else if (type === "MasterCard") {
        var cardType = "master_card"
      } else if (type === "Discover") {
        var cardType = "discover"
      } else {
        var cardType = "generic_card"
      }

      $("i.card_type img", $(el).parent()).hide();
      $("i.card_type img." + cardType, $(el).parent()).show();
    }

    $("input#order_card_number", this.newCreditCardPanel).off("input").on("input", function() {
      changeCreditCardIcon(this)
    });
  };

  SelectPaymentMethodModal.fn.assign = function() {
    $(".new_credit_card_panel form", this.el)[0].reset();
    $(".new_credit_card_panel #order_card_number", this.el).mask("0000 0000 0000 0000")

    this.setPackage();
    this.showFirstPanel();
  };

  SelectPaymentMethodModal.fn.showFirstPanel = function() {
    var cards = $("ul.credit_cards li", this.selectCardPanel);

    if (cards.length > 0) {
      $("a[data-sub-panel='select_card_panel']", this.newCreditCardPanel).show();
      this.selectCardPanel.show();
      this.newCreditCardPanel.hide();
    } else {
      $("a[data-sub-panel='select_card_panel']", this.newCreditCardPanel).hide();
      this.selectCardPanel.hide();
      this.newCreditCardPanel.show();
    }
  }

  SelectPaymentMethodModal.fn.setPackage = function() {
    $(".package-credits", this.el).html(this.package.credits);
    $(".package-price", this.el).html(this.package.price);

    this.el.data("package-id", this.package.id);
    this.el.find("form input[name='order[package_id]']").val(this.package.id)
  };

  SelectPaymentMethodModal.fn.initNewCreditCardPayment = function(attributes) {
    var form = this.el.find(".new_credit_card_panel form")
    Module.run("IHP.Main.Modal.Payment", form);
  };

  SelectPaymentMethodModal.fn.bindNavigation = function(attributes) {
    this.el.off("click", "nav li").on("click", "nav li", function() {
      $(this).siblings().removeClass("tab_selected");
      $(this).addClass("tab_selected");
    });

    this.el.off("click", "nav li[data-panel]").on("click", "nav li[data-panel]", function() {
      var panel = $(this).data("panel");
      $(".modal_panel").hide();
      $(".modal_panel." + panel).show();
    });

    this.el.off("click", "a[data-sub-panel]").on("click", "a[data-sub-panel]", function(e) {
      e.preventDefault();
      var panel = $(this).data("sub-panel");
      $(".sub_modal_panel").hide();
      $(".sub_modal_panel." + panel).show();
    });
  };

  SelectPaymentMethodModal.fn.cardSelection = function(attributes) {
    this.el.off("click", "ul.credit_cards li").on("click", "ul.credit_cards li", function(e) {
      e.preventDefault();

      $(this).siblings().removeClass("cc_selected");
      $(this).addClass("cc_selected");
    });
  };

  SelectPaymentMethodModal.fn.deleteCard = function(e) {
    e.stopPropagation();

    var $button = $(e.target);
    $button.closest("li").fadeOut(function() {
      $button.closest("li").remove();
      this.showFirstPanel();
    }.bind(this));
  };
});
