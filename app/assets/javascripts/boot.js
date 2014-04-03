$(document).ready(function() {
  var body = $("body");
  var page = body.data("page");

  Module.run("IHP.Components.PsychicCards", [body]);
  Module.run("IHP.Components.SignIn", [body]);
  Module.run("IHP.Components.SignInForm", [body]);

  if (page) {
    Module.run("IHP.Pages." + page, [body]);
  }
});
