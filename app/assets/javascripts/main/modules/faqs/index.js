Module("IHP.Pages.FaqsIndex", function(FaqsIndex) {
  "use strict";

  FaqsIndex.fn.initialize = function(el) {
    this.el = $(el);
    this.categories = this.el.find(".categories");
    this.faqs = this.el.find(".faqs");

    this.category = this.el.attr("data-selected-category");
    this.category = this.category || this.extractSlug(document.location.toString());
    this.category = this.category || this.extractSlug(this.categories.find(".category:first").attr("href"));

    this.addEventListeners();
    this.showCategory();
  };

  FaqsIndex.fn.addEventListeners = function() {
    this.categories.on("click", ".category", this.changeCategory.bind(this));
    this.faqs.on("click", ".faqs-entry", this.changeFaq.bind(this));
  };

  FaqsIndex.fn.changeFaq = function(e) {
    this.faqs.find(".faqs-entry.active").removeClass("active");
    this.faqs.find(e.target).closest("section").addClass("active");
  };

  FaqsIndex.fn.changeCategory = function(e) {
    var url = this.categories.find(e.target).attr("href"),
        slug = this.extractSlug(url);

    location.hash = this.category = slug;

    this.showCategory();
  };

  FaqsIndex.fn.showCategory = function() {
    this.categories.find(".category.selected").removeClass("selected");
    this.categories.find(".faqs-link-" + this.category).addClass("selected");

    this.faqs.find(".faq.selected").removeClass("selected");
    this.faqs.find(".faqs-" + this.category).addClass("selected");;
    this.faqs.find(".faqs-entry.active").removeClass("active");
    this.faqs.find(".faqs-entry:visible:first").closest("section").addClass("active");
  };

  FaqsIndex.fn.extractSlug = function(url) {
    var parts = url.split("#");

    if (parts.length > 1) {
      return parts[1];
    } else {
      return null;
    }
  };
});
