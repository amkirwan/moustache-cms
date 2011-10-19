//= require jquery
//= require jquery_ujs
//= require markitup_selector
//= require admin/pages
//= require admin/theme_assets
//= require admin/site_assets
//= require admin/current_site
//= require plupload/plupload.full.js
//= require plupload/jquery.plupload.queue/jquery.plupload.queue.js
//= require_self

jQuery(function() {
  return $(document).ready(function() {
    $('#flash_notice_wrapper').delay(2000).fadeToggle('slow', 'linear', function() {
      $(this).remove()
    }); 

    $('.foldable legend').mouseup(function() {
      var legend = $(this);
      legend.next('ul.form_fields').slideToggle('slow', 'linear', function() {
        var arrow = legend.children().first();
        if (arrow.hasClass('rotate')) {
          arrow.removeClass('rotate');
        } else { 
          arrow.addClass('rotate');
        }
      });
    });
  });
});

