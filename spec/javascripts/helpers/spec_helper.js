// includes Stripe from CDN
var head = document.getElementsByTagName('head')[0];
var jQueryScript = document.createElement('script');
jQueryScript.setAttribute('type', 'text/javascript');
jQueryScript.setAttribute('src', "https://js.stripe.com/v2/");
head.appendChild(jQueryScript);

beforeEach(function() {
  jQuery.fx.off = true;
  $("<div class='output'/>").appendTo("body");
});

afterEach(function() {
  $(".output").remove();
});
