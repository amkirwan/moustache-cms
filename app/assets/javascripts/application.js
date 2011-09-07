//= require jquery
//= require jquery_ujs
//= require markitup_selector
//= require foldable
//= require_self

$(document).ready(function(){

  // configure editor

  /* body.page markitup */

  if ($('body.layouts').length) {
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
  } else if ($('body.theme_assets').length) {
    $('textarea.code').markItUp(cssSettings);
  }
  /* end body.page */
});
