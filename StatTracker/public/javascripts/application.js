// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  $(document).ready(function() {

		jQuery(function($) {
		  // when the #search field changes
		  $("#chart_type").change(function() {
			// make a POST call and replace the content
			$.post(<%= change_chart_batting_path(:players => @players) %>, function(data) {
			  $("#chart_place").html(data);
			});
		  });
		})
  });
