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
	
jQuery(function($) {

	  $("#batting_advanced_link")
		.bind("ajax:success", function(event, data, status, xhr) {
		  $("#batting_advanced").html(data);
		});
	});
	
	
jQuery(function($) {

		$("#batting_advanced_button").click( function () {
			$("#batting_simple").hide();
			$("#batting_advanced_button").hide();
			$("#batting_advanced").show();
			$("#batting_simple_button").show();
		});
	});
	
	jQuery(function($) {

		$("#batting_simple_button").click( function () {
			$("#batting_advanced").hide();
			$("#batting_simple_button").hide();
			$("#batting_simple").show();
			$("#batting_advanced_button").show();
		});
	});
	
	jQuery(function($) {

		$("#batting_post_advanced_button").click( function () {
			$("#batting_post_simple").hide();
			$("#batting_post_advanced_button").hide();
			$("#batting_post_advanced").show();
			$("#batting_post_simple_button").show();
		});
	});
	
	jQuery(function($) {

		$("#batting_post_simple_button").click( function () {
			$("#batting_post_advanced").hide();
			$("#batting_post_simple_button").hide();
			$("#batting_post_simple").show();
			$("#batting_post_advanced_button").show();
		});
	});