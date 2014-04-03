function scheduleElementFinder(content, $link) {
  var $tr = $link.closest("tr");
  var date = $tr.data("date");
  var $td = $tr.children("td:first");
  var rowspan = parseInt($td.attr("rowspan"), 10);

  // increases the rowspan to include this new row
  $td.attr("rowspan", rowspan + 1);

  content.attr("data-date", date);
  content.find("input[type=hidden].date").val(date);

  if (rowspan <= 1) {
    // inserts after the row itself
    content.insertAfter($tr);
  }
  else {
    // inserts after the last row for this date
    content.insertAfter($tr.siblings("tr[data-date='" + date + "']:last"));
  }

  return false;
}

function removeSchedule(link) {
  $link = $(link);
  $tr = $link.parents("tr");
  var date = $tr.data("date");
  $fTr = $tr.siblings("tr[data-date='" + date + "']:first");
  $td = $fTr.children("td:first");
  var rowspan = parseInt($td.attr("rowspan"), 10);
  $td.attr("rowspan", rowspan - 1);

  $link.prev("input[type=hidden]").val("1");

  // if this is an initial row
  if ($tr.children("td").length == 3) {
    $tr.find("input.start_time").val("");
    $tr.find("input.end_time").val("");
  }
  else {
    // removing is alright
    $tr.hide();
  }
}
