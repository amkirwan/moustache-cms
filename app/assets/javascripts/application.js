//= require jquery
//= require jquery_ujs
//= require markitup_selector
//= require admin/pages
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

