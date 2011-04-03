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

// jQuery(function($) {

  // $("#chart_type").change(function() {
 /*    make a POST call and replace the content */
    // $.post(<%= change_chart_batting_path(:players => @players) %>, function(data) {
      // $("#chart_place").html(data);
    // });
  // });
// })