// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){

  // configure editor
  //$('textarea#layout_content').markItUp(mySettings);

  /* body.page markitup */
  if($('body.pages').length) {

    $('.page_part_filter option:selected').each(function() {
      var filter_text = $(this).text();

      if (filter_text == "markdown") {
        $("textarea.page_part_contents").markItUp(markdownSettings);
      } else if (filter_text == "textile") {
        $("textarea.page_part_contents").markItUp(textileSettings);
      } else if (filter_text == "html") {
        $("textarea.page_part_contents").markItUp(htmlSettings);
      }
    });
    
    $('.page_part_filter').change(function() {
      $('.page_part_filter option:selected').each(function() {
        var filter_text = $(this).text();

        $('textarea.page_part_contents').markItUpRemove();
        if (filter_text == "markdown") {
          $("textarea.page_part_contents").markItUp(markdownSettings);
        } else if (filter_text == "textile") {
          $("textarea.page_part_contents").markItUp(textileSettings);
        } else if (filter_text == "html") {
          $("textarea.page_part_contents").markItUp(htmlSettings);
        }
      });
    });
  } else if ($('body.layouts').length) {
    $('textarea.code').markItUp(htmlSettings);
  }
  /* end body.page */
});
