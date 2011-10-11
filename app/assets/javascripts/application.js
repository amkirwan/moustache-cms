//= require jquery
//= require jquery_ujs
//= require markitup_selector
//= require admin/pages
//= require admin/theme_assets
//= require_self

jQuery(function() {
  return $(document).ready(function() {
    $('#flash_notice_wrapper').delay(2000).fadeToggle('slow', 'linear', function() {
      $(this).remove()
    }); 
  });
});
