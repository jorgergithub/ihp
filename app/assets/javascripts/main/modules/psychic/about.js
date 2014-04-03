$(document).ready(function() {
  var showPage = function(arrow, page) {
    $(arrow).siblings("article").removeClass("psychic-selected");
    $(arrow).siblings("article[data-page='" + page + "']").addClass("psychic-selected");
  }

  $(".psychic-reviews .psychic-left-arrow").on("click", function() {
    var currentPage = $(this).siblings(".psychic-selected").data("page");
    var page = currentPage - 1;
    if (page < 0) {
      var page = 0;
    }

    showPage(this, page);
  });

  $(".psychic-reviews .psychic-right-arrow").on("click", function() {
    var currentPage = $(this).siblings(".psychic-selected").data("page");
    var pageAmount = $(this).siblings("article").length;

    var page = currentPage + 1;
    if (page > pageAmount - 1) {
      var page = pageAmount - 1;
    }

    showPage(this, page);
  });

  var calculateSchedualDisplay = function () {
    var rows = $(".psychic-schedule table tbody tr");
    $.each(rows, function(row_index, row) {
      var $row = $(row);
      $.each($("td", $row), function(cell_index, cell) {
        var $cell = $(cell);
        var $upCell = $row.prev().find("td:eq(" + cell_index + ")");

        if ($upCell.hasClass("psychic-available") && $cell.hasClass("psychic-available")) {
         $cell.addClass("middle");

          var $downCell = $row.next().find("td:eq(" + cell_index + ")");
          if (!$downCell.hasClass("psychic-available")) {
            $cell.removeClass("middle");
          }
        }
      });
    });
  }();
});
