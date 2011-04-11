// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function($) {

  $("#change_chart")
    .bind("ajax:success", function(event, data, status, xhr) {
      $("#chart_place").html(data);
    });
});

jQuery(function($) {

  $("#change_table")
    .bind("ajax:success", function(event, data, status, xhr) {
      $("#table_place").html(data);
    });
});

jQuery(function($) {

  $("#years")
    .bind("ajax:success", function(event, data, status, xhr) {
      $("#years_place").html(data);
    });
});
