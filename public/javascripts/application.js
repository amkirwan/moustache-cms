// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){

  // configure editor

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
    
    $('.foldable fieldset legend').mouseup(function() {
      var legend = $(this);
      legend.next("ul.form_fields").slideToggle("slow", function() {
        if ( legend.children().first().hasClass("span_rotate") ) {
          legend.children().first().removeClass('span_rotate');
        } else {
          legend.children().first().addClass('span_rotate');
        }
      });
    });

  } else if ($('body.layouts').length) {
    $('textarea.code').markItUp(htmlSettings);
  } else if ($('body.snippets').length) {
      $('#snippet_filter_name option:selected').each(function() {
        var filter_text = $(this).text();

        if (filter_text == "markdown") {
          $("textarea#snippet_content").markItUp(markdownSettings);
        } else if (filter_text == "textile") {
          $("textarea#snippet_content").markItUp(textileSettings);
        } else if (filter_text == "haml") {
          $("textarea#snippet_content").markItUp(defaultSettings);
        } else if (filter_text == "html") {
          $("textarea#snippet_content").markItUp(htmlSettings);
        }
      });

      $('#snippet_filter_name').change(function() {
        $('#snippet_filter_name option:selected').each(function() {
          var filter_text = $(this).text();

          $('textarea#snippet_content').markItUpRemove();
          if (filter_text == "markdown") {
            $("textarea#snippet_content").markItUp(markdownSettings);
          } else if (filter_text == "textile") {
            $("textarea#snippet_content").markItUp(textileSettings);
          } else if (filter_text == "haml") {
            $("textarea#snippet_content").markItUp(defaultSettings);
          } else if (filter_text == "html") {
            $("textarea#snippet_content").markItUp(htmlSettings);
          }
        });
      });
  }
  /* end body.page */
});
