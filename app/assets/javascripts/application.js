//= require login_focus
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require admin/ace
//= require ace_editor
//= require admin/jquery.cookies.min
//= require admin/pages
//= require admin/articles
//= require admin/meta_tags
//= require admin/custom_fields
//= require admin/theme_assets
//= require admin/site_assets
//= require admin/current_site
//= require plupload_uploader 
//= require nested/jquery.ui.nestedSortable
//= require jquery.fancybox.pack
//= require_self

$(document).ready(function() {
  $('#flash_notice_wrapper').delay(1500).fadeToggle('slow', 'linear', function() {
    $(this).remove()
  }); 

  //Display Moustache Tags Helpers  
  $('.documentation').fancybox({
    'maxHeight': 400,
    'maxWidth': 600,
    'height': '70%'
  });

  $('.foldable legend').mouseup(function() {
    var legend = $(this);
    legend.siblings().slideToggle('slow', 'linear', function() {
      var arrow = legend.children().first();
      if (arrow.hasClass('rotate-ccw')) {
        arrow.removeClass('rotate-ccw');
      } else { 
        arrow.addClass('rotate-ccw');
      }
    });
  });

  $('fieldset.page_parts').mouseup(function() {
    var legend = $(this);
    legend.siblings('div#page_parts_wrapper').slideToggle('slow', 'linear', function() {
      var arrow = legend.children().first();
      if (arrow.hasClass('rotate')) {
        arrow.css('background-position', '0 0')
        arrow.css('width', '6px')
        arrow.css('top', '0')
        arrow.removeClass('rotate');
      } else { 
        arrow.css('background-position', '-6px 0')
        arrow.css('width', '9px')
        arrow.css('top', '1px')
        arrow.addClass('rotate');
      }
    });
  });

  $('.logout').on('click', function() {
    sessionStorage.clear();
  });

});
