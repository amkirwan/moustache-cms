//= require jquery
//= require jquery_ujs
//= require markitup_selector
//= require admin/pages
//= require_self

jQuery(function() {
  return $(document).ready(function() {
    $('#flash_notice_wrapper').delay(3000).fadeToggle('slow', 'linear', function() {
      $(this).remove()
    }); 
  });
});
