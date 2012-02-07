//= require login_focus
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require admin/pages
//= require admin/articles
//= require admin/meta_tags
//= require admin/custom_fields
//= require admin/theme_assets
//= require admin/site_assets
//= require admin/current_site
//= require plupload/plupload.full
//= require plupload/jquery.plupload.queue/jquery.plupload.queue
//= require site_asset_plupload
//= require nested/jquery.ui.nestedSortable
//= require_self

$(document).ready(function() {
  $('#flash_notice_wrapper').delay(3000).fadeToggle('slow', 'linear', function() {
    $(this).remove()
  }); 

  $('.foldable legend').mouseup(function() {
    var legend = $(this);
    legend.siblings().slideToggle('slow', 'linear', function() {
      var arrow = legend.children().first();
      if (arrow.hasClass('rotate')) {
        arrow.removeClass('rotate');
      } else { 
        arrow.addClass('rotate');
      }
    });
  });

  $('fieldset.page_parts').mouseup(function() {
    var legend = $(this);
    legend.siblings('div#page_parts_wrapper').slideToggle('slow', 'linear', function() {
      var arrow = legend.children().first();
      if (arrow.hasClass('rotate')) {
        arrow.removeClass('rotate');
      } else { 
        arrow.addClass('rotate');
      }
    });
  });

});
