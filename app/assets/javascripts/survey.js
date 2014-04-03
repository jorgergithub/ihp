function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content, elementFinder) {
  var new_id = new Date().getTime();
  var regex = new RegExp("new_" + association, "g");
  var $link = $(link);
  var replacedContent = $(content.replace(regex, new_id))

  var insertBefore;

  if (elementFinder) {
    insertBefore = elementFinder(replacedContent, $link);
    if (!insertBefore) {
      return;
    }
  }
  else {
    if ($link.parent().is(".controls")) {
      insertBefore = $link.parent().parent();
    }
    else {
      insertBefore = link;
    }
  }

  replacedContent.insertBefore(insertBefore);
}
